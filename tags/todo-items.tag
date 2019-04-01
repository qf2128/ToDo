<todo-items>
<div class="card">
    <div class="card-body">
       <h4> TODO &mdash;{list.title} </h4

     	<ul>
     		<li each={ todo in items.filter(whatShow) } if={todo.listName==list.title}>
     			<label class={ completed: todo.done }>
     				<input type="checkbox" checked={ todo.done } onclick={ parent.toggle }>
     				{ todo.title }
     			</label>
     		</li>
     	</ul>


     	<form onsubmit={ add }>
     		<input ref="input" onkeyup={ editTodo } placeholder="add your Todo item">
     		<button disabled={ !text }>Add #{ items.filter(whatShow).length + 1 }</button>

     		<button type="button" disabled={ items.filter(onlyDone).length == 0 } onclick={ removeAllDone }>
     			X{ items.filter(onlyDone).length }
     		</button>
     	</form>



    </div>
</div>



    <script>
this.items = opts.items || [];

editTodo(event) {
			this.text = event.target.value;
		}

		add(event) {
			if (this.text) {

				let todo = {
					title: this.text,
					done: false,
                    listName: this.list.title
				};

				// DATABASE WRITE
				database.collection('todos').add(todo).then(doc => {
					console.log('Document successfully created!');

					todo.id = doc.id;
					this.items.push(todo);

					this.update();
				});

				this.text = this.refs.input.value = '';
			}

			event.preventDefault();
		}

		removeAllDone(event) {
			let doneTodos = this.items.filter(item => item.done);

			let todosRef = database.collection('todos');

			for (todo of doneTodos) {

				// DATABASE DELETE
				todosRef.doc(todo.id).delete().then( () => {
					console.log('Document successfully deleted!');
				});
			}

			this.items = this.items.filter(item => !item.done);
		}

		toggle(event) {
			let item = event.item.todo;
			item.done = !item.done;
			return true;
		}

		// FILTER FUNCTIONS ----------------------------------------

		whatShow(item) {
			return !item.hidden;
		}

		onlyDone(item) {
			return item.done;
		}

        this.on('mount', () => {

			// DATABASE READ
			database.collection('todos').get().then(snapshot => {
				console.log('Collection successfully fetched.');

				this.items = [];

				snapshot.forEach(doc => {
					let todo = doc.data();
							todo.id = doc.id;
					this.items.push(todo);
				});

				this.update();
			});
		});




    </script>


</todo-items>
