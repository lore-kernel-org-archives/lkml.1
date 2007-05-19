Return-Path: <linux-kernel-owner+w=401wt.eu-S1761049AbXESKni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761049AbXESKni (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 06:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbXESKnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 06:43:31 -0400
Received: from mx6.mail.ru ([194.67.23.26]:1865 "EHLO mx6.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756391AbXESKnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 06:43:31 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc2: section mismatch
Date: Sat, 19 May 2007 14:43:21 +0400
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1555744.UOT7ZxZVBn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705191443.27161.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1555744.UOT7ZxZVBn
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

  MODPOST vmlinux
WARNING: init/built-in.o - Section mismatch: reference to .init.text:=20
from .text between 'rest_init' (at offset 0x11b) and 'try_name'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference=20
to .init.text:amd_init_mtrr from .text between 'mtrr_bp_init' (at offset=20
0x967a) and 'mtrr_attrib_to_str'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference=20
to .init.text:cyrix_init_mtrr from .text between 'mtrr_bp_init' (at offset=
=20
0x967f) and 'mtrr_attrib_to_str'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference=20
to .init.text:centaur_init_mtrr from .text between 'mtrr_bp_init' (at offse=
t=20
0x9684) and 'mtrr_attrib_to_str'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference=20
to .init.text: from .text between 'get_mtrr_state' (at offset 0xa735)=20
and 'generic_get_mtrr'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference=20
to .init.text: from .text between 'get_mtrr_state' (at offset 0xa749)=20
and 'generic_get_mtrr'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference=20
to .init.text: from .text between 'get_mtrr_state' (at offset 0xa770)=20
and 'generic_get_mtrr'
WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .t=
ext=20
between 'kmem_cache_create' (at offset 0x1bffd) and 'cache_reap'
WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .t=
ext=20
between 'kmem_cache_create' (at offset 0x1c232) and 'cache_reap'

--nextPart1555744.UOT7ZxZVBn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGTtTKR6LMutpd94wRAluuAJ4welFZr+wq9Q3YhdWQqsPfTaLSQwCfXjqu
VrC/4VjEE8H7B7lp0MCfhI4=
=M98A
-----END PGP SIGNATURE-----

--nextPart1555744.UOT7ZxZVBn--
