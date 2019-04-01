<app>
     <h1>TODO</h1>

     <ul>
		<li each={ list in lists.filter(whatShowList) }>
			<label class={ completed: list.done }>
                <input type="checkbox" checked={ list.done } onclick={ parent.toggleList }>
				{ list.title }
			</label>
		</li>
	</ul>

     <form onsubmit={ addList }>
     <input ref="listInput" onkeyup={ editList } placeholder="
     create a new Todo list">
     <button disabled={ !listText }>Add #{ lists.filter(whatShowList).length }</button>
     <button type="button" disabled={ lists.filter(onlyDoneList).length == 0 } onclick={ removeAllDone }>
			X{ lists.filter(onlyDoneList).length }
		</button>
     </form>


<div class="container-fluid">
    <div class="row">
        <div class="col-md-6">

            <todo-items each={ list, i in lists } > </todo-items>

            </div>
    </div>

    </div>




     <script>
     this.listText=""


        editList(event) {
            this.listText = event.target.value;
        }

        addList(event){
            console.log('List successfully created!');
            if(this.listText){
                 let list={
                      title: this.listText,
                      done: false
                 }

                // DATABASE WRITE
                database.collection('lists').add(list).then(doc => {
                    console.log('List successfully created!');
					list.id = doc.id;
                    this.lists.push(list);
					this.update();
				});

				this.listText = this.refs.listInput.value = '';
			}
            event.preventDefault();
        }

removeAllDone(event) {
    let doneLists = this.lists.filter(item => item.done);

    let listsRef = database.collection('lists');

    for (list of doneLists){

       // DATABASE DELETE
       listsRef.doc(list.id).delete().then(()=>{
           console.log('Document successfully deleted!');
          })
       }
       this.lists = this.lists.filter(item => !item.done);
    }

whatShowList(item){
    return !item.hidden;
}

onlyDoneList(item) {
	return item.done;
		}

toggleList(event) {
        			var item = event.item.list;
                    console.log(event)
        			item.done = !item.done;
        			return true;
        		}

        this.on('mount', () => {

  			// DATABASE READ
  			database.collection('lists').get().then(snapshot => {
  				console.log('Collection successfully fetched.');

  				this.lists = [];

  				snapshot.forEach(doc => {
  					let list = doc.data();
  							list.id = doc.id;
  					this.lists.push(list);
  				});

  				this.update();
  			});
  		});


     </script>

</app>
