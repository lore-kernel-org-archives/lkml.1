Return-Path: <linux-kernel-owner+w=401wt.eu-S933709AbYBMR22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709AbYBMR22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757743AbYBMR2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:28:19 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:53520 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331AbYBMR2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:28:18 -0500
Date: Wed, 13 Feb 2008 18:28:00 +0100
From: Christian Krafft <krafft@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, parabelboi@bopserverein.de
Subject: [Patch 0/2] add check_legacy_ioport calls to prevent oops
Message-ID: <20080213182800.5c6940a8@de.ibm.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/SZZ6uCqtwy11xHhoEwyju4+";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/SZZ6uCqtwy11xHhoEwyju4+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

the following two patches prevent kernel from crashing on powerpc.
The surrounding ifdefs will be obsolete, if check_legacy_ioport becomes
generic code.


--=20
Mit freundlichen Gruessen,
kind regards,

Christian Krafft
IBM Systems & Technology Group,
Linux Kernel Development
IT Specialist


Vorsitzender des Aufsichtsrats:	Martin Jetter
Geschaeftsfuehrung:		Herbert Kircher
Sitz der Gesellschaft:		Boeblingen
Registriergericht:		Amtsgericht Stuttgart, HRB 243294

--Sig_/SZZ6uCqtwy11xHhoEwyju4+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHsyiw6rqK4qDx+dcRAoIvAJ9w1s5v2gHg0k1qrA5RQ3E9rUKABgCaAzCx
lrEY306uD08TWw5tv2aOvUI=
=U3qV
-----END PGP SIGNATURE-----

--Sig_/SZZ6uCqtwy11xHhoEwyju4+--
