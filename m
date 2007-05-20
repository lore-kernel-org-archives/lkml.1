Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbXETLYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbXETLYk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 07:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbXETLYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 07:24:32 -0400
Received: from smtpout.hostsharing.net ([83.223.95.15]:35737 "EHLO
	smtpout.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbXETLYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 07:24:31 -0400
Date: Sun, 20 May 2007 13:24:26 +0200
From: Elimar Riesebieter <riesebie@lxtec.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc2 built on ppc (5)
Message-ID: <20070520112426.GJ3253@aragorn.home.lxtec.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QnBU6tTI9sljzm9u"
Content-Disposition: inline
Organization: LXTEC
X-Editor: VIM - Vi IMproved 7.1 (2007 May 12, compiled May 15 2007 21:24:37)
User-Agent: Mutt/1.5.15+lxtec (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--QnBU6tTI9sljzm9u
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

FYI, building the kernel with
gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)
on my powerbook (PPC) gives:

=2E..
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from dt_string_start (offset 0x8)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from dt_string_end (offset 0xc)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from prom_entry (offset 0x10)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from prom (offset 0x40)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from of_platform (offset 0x54)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from mem_reserve_cnt (offset 0x5c)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from mem_reserve_map (offset 0x64)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from alloc_bottom (offset 0x68)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from ram_top (offset 0x6c)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from alloc_top (offset 0x74)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from prom_scratch (offset 0x90)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from dt_header_start (offset 0xc0)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from dt_struct_start (offset 0xc8)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from dt_struct_end (offset 0xd0)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from of_stdout_device (offset 0x120)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from prom_initrd_start (offset 0x150)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from prom_initrd_end (offset 0x154)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from prom_cmd_line (offset 0x160)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from regbuf (offset 0x17c)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from rmo_top (offset 0x184)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from alloc_top_high (offset 0x18c)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .i=
nit.data:.got2 from disp_BAT (offset 0x25c)
WARNING: arch/powerpc/mm/built-in.o - Section mismatch: reference to .init.=
text:early_get_page from .text between 'pte_alloc_one_kernel' (at offset 0x=
13e8) and 'v_mapped_by_bats'
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.data:mv643xx_eth_pd_devs from .text between 'mv643xx_eth_add_pds' (a=
t offset 0xd74e) and 'chrp_pci_fixup_winbond_ata'
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.data:mv643xx_eth_pd_devs from .text between 'mv643xx_eth_add_pds' (a=
t offset 0xd752) and 'chrp_pci_fixup_winbond_ata'
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.text:note_scsi_host from __ksymtab between '__ksymtab_note_scsi_host=
' (at offset 0x8) and '__ksymtab_sys_ctrler'
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.data:.got2 from  (offset 0x0)
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.data:.got2 from bootx_dt_strend (offset 0x4)
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.data:.got2 from bootx_node_chosen (offset 0x30)
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.data:.got2 from bootx_info (offset 0x34)
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.data:.got2 from bootx_disp_path (offset 0x40)
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.text:pmac_probe from .machine.desc between 'mach_powermac' (at offse=
t 0x4) and 'mach_chrp'
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.text:pmac_setup_arch from .machine.desc between 'mach_powermac' (at =
offset 0x8) and 'mach_chrp'
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.text:pmac_init_early from .machine.desc between 'mach_powermac' (at =
offset 0xc) and 'mach_chrp'
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.text:pmac_pic_init from .machine.desc between 'mach_powermac' (at of=
fset 0x18) and 'mach_chrp'
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.text:pmac_time_init from .machine.desc between 'mach_powermac' (at o=
ffset 0x44) and 'mach_chrp'
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.text:pmac_calibrate_decr from .machine.desc between 'mach_powermac' =
(at offset 0x5c) and 'mach_chrp'
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.text:pmac_pcibios_after_init from .machine.desc between 'mach_powerm=
ac' (at offset 0xc4) and 'mach_chrp'
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.text:chrp_probe from .machine.desc after 'mach_chrp' (at offset 0xd0)
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.text:chrp_setup_arch from .machine.desc after 'mach_chrp' (at offset=
 0xd4)
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.text:chrp_init_IRQ from .machine.desc after 'mach_chrp' (at offset 0=
xe4)
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.text:chrp_time_init from .machine.desc after 'mach_chrp' (at offset =
0x110)
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to=
 .init.text:chrp_init2 from .machine.desc after 'mach_chrp' (at offset 0x17=
0)
WARNING: mm/built-in.o - Section mismatch: reference to .init.text:set_up_l=
ist3s from .text between 'kmem_cache_create' (at offset 0x24fe0) and 'kmem_=
cache_shrink'
WARNING: mm/built-in.o - Section mismatch: reference to .init.text:set_up_l=
ist3s from .text between 'kmem_cache_create' (at offset 0x250fc) and 'kmem_=
cache_shrink'
arch/powerpc/boot/flatdevtree.c:139: warning: 'ft_ordered' defined but not =
used
ld: arch/powerpc/boot/coff.o: No such file: No such file or directory
nm: 'arch/powerpc/boot/zImage.coff': No such file
objdump: 'arch/powerpc/boot/zImage.coff': No such file
<stdin>:1340:2: warning: #warning syscall sync_file_range not implemented
=2E..

If more info is needed, please contact me via PM, as I am not
subscribed.

Thanks for your patience
Elimar

--=20
  Never make anything simple and efficient when a way=20
  can be found to make it complex and wonderful ;-)

--QnBU6tTI9sljzm9u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGUC/p3Ig8bsVPf7ARAm4lAKCR84U/3OSUFkqjRQYY3l9gJq8yBwCffihh
vkQE/3N7K//ImqEsBC3ERe0=
=hR6a
-----END PGP SIGNATURE-----

--QnBU6tTI9sljzm9u--
