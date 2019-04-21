$(function() {
  $('#dataTable').DataTable({
    paging: true,
    searching: true,
    ordering: true,
    language: {
      search: 'Buscar',
      paginate: {
        first: 'Primero',
        previous: 'Anterior',
        next: 'Siguiente',
        last: 'Último'
      },
      info: 'Mostrando _START_ de _END_ registros',
      lengthMenu: 'Mostrar _MENU_ registros'
    }
  });
});