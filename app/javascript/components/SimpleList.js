import React from "react";

const SimpleList = ({ title, tokens, action }) => {
  return (
    <>
      <h3>{title}</h3>
      <ListOrEmptyPage tokens={tokens} action={action}/>
    </>
  );
};

const ListOrEmptyPage = React.memo(({ tokens, action }) => {
  return tokens.length === 0 ? <EmptyPage/> : <UnorderedList tokens={tokens} action={action}/>;
});

const EmptyPage = () => {
  return <p>There are no tokens yet</p>;
};

const UnorderedList = ({ tokens, action }) => {
  return (
    <ul>
      {tokens.map((t) => <li key={t}>{t} <a href="#" onClick={action.func(t)}>{action.name}</a></li>)}
    </ul>
  );
};

export default SimpleList;
