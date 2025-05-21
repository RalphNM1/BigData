## Variables
#source $HOME/openstack.sh
export usuario="xuedua093"
export centro="wirtz"
export sabor="a1.4c8m"
export rede="provnet-formacion-vlan-133"
export nome_keypair="kp-${centro}-${usuario}"
export grupo_seguridad="sg-${centro}-${usuario}"
export imaxe_favorita="baseos-Rocky-8.7-v4 "
export gigas_volume=25

## Cargar openstack
module load openstack
source /opt/cesga/openstack/osc.bash_completion
source ./openstack.sh

## Generar ssh-key
ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""

## Borrar par de claves (por si existe)
openstack keypair delete ${nome_keypair}

## Crear par de claves
openstack keypair create --public-key ~/.ssh/id_rsa.pub ${nome_keypair}

## Borrar grupo de seguridad
openstack security group delete ${grupo_seguridad}

## Crear grupo de seguridad
openstack security group create ${grupo_seguridad}

## Añadir reglas al grupo de seguridad
openstack security group rule create --proto tcp --dst-port 22 --ingress --remote-ip 0.0.0.0/0 ${grupo_seguridad}

## Listar reglase del grupo de seguridad
# openstack security group rule list ${grupo_seguridad}

## Listar instancias creadas por mi (xuedua093)
#openstack server list|grep xuedua093

# Ver id imagen 
#openstack image show -f value -c id baseos-Rocky-8.7-v4 


## Bucle para crear instancias de cesga
crear4instancias() {
	for numero in {1..4}; do \
		openstack server create --boot-from-volume ${gigas_volume} --image ${imaxe_favorita} --flavor ${sabor} --key-name ${nome_keypair} --network ${rede} --security-group ${grupo_seguridad} ${centro}-${usuario}-hadoop${numero}; done
	openstack server list|grep xuedua093
}

recuperaxvolumen() {
        for numero in {1..4}; do \
                openstack server create \
                        --flavor ${sabor} \
                        --volume vol-${centro}-${usuario}-hadoop${numero} \
                        --security-group sg-${centro}-${usuario} \
                        --key-name kp-${centro}-${usuario} \
                        --network ${rede} \
                        ${centro}-${usuario}-hadoop${numero} ; done
		
		openstack server list|grep xuedua093
}

borrarInstancias() {
		for numero in {1..4}; do \
			openstack server delete ${centro}-${usuario}-hadoop${numero} ; done
		openstack server list|grep xuedua093
}

#crear4instancias
recuperaxvolumen

## Actualizar máquinas
#sudo dnf update -y


# crear1instancia() {
	# openstack server create \
	# --flavor ${sabor} \
	# --key-name ${nome_keypair} \
	# --network ${rede} \
	# --security-group ${grupo_seguridad} \
	# --block-device source=image,id=$(openstack image show -f value -c id ${imaxe_favorita}),dest=volume,size=${gigas_volume},bootindex=0,shutdown=remove,volume_type=default,device=/dev/vda,tag=boot,volume_name=volume-${usuario} \
	# ${centro}-${usuario}-hadoop1
# }

# crear1instancia

# openstack server delete wirtz-xuedua093-hadoop1


# --block-device source=image,id=$(openstack image show -f value -c id ${imaxe_favorita}),dest=volume,size=${gigas_volume},bootindex=0,shutdown=remove,volume_type=default,device=/dev/vda,tag=boot,volume_name=volume-${usuario} \
	# ${centro}-${usuario}-hadoop1
	
	#vol-wirtz-xuedua093-hadoop1
	
	
# openstack server create --flavor a1.4c8m --volume vol-wirtz-xuedua093-hadoop1 --security-group sg-wirtz-xuedua093 --key-name kp-wirtz-xuedua093 --network provnet-formacion-vlan-133 wirtz-xuedua093-hadoop1
						
						
# /tmp/hadoop-cesgaxuser-namenode.pid