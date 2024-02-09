import logo from './logo.svg';
import './App.css';

function App() {
  return (
    <div className="App">
     <aside className='side-menu'>
      <div className='side-menu-button'>
        <span>+</span>
        
        
        NEW CHAT</div>
     </aside>
     <section className='chatbox'>

      <div className='chat-input' >

      <textarea placeholder='Enter your prompt here'
      rows={1}
      className='chat-input-textarea'>

      </textarea>


      </div>

     </section>
    </div>
  );
}

export default App;
