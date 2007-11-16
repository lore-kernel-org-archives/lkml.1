Return-Path: <linux-kernel-owner+w=401wt.eu-S932123AbXKPMbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbXKPMbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 07:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbXKPMbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 07:31:15 -0500
Received: from enterprise.ram.RWTH-Aachen.DE ([137.226.68.2]:33382 "EHLO
	enterprise.ram.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755190AbXKPMbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 07:31:14 -0500
X-Greylist: delayed 1368 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Nov 2007 07:31:14 EST
Date: Fri, 16 Nov 2007 13:11:48 +0100
From: markus reichelt <ml@mareichelt.de>
To: linux-kernel@vger.kernel.org
Subject: Re: NFS Bug in 2.6.23 ?
Message-ID: <20071116121148.GI4290@tatooine.rebelbase.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <473D6B5C.4090701@abinetworks.biz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
In-Reply-To: <473D6B5C.4090701@abinetworks.biz>
Organization: still stuck in reorganization mode
X-PGP-Key: 0xC2A3FEE4
X-PGP-Fingerprint: FFB8 E22F D2BC 0488 3D56  F672 2CCC 933B C2A3 FEE4
X-Request-PGP: http://mareichelt.de/keys/c2a3fee4.asc
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Gianluca Alberici <gianluca@abinetworks.biz> wrote:

> If i cd into it and ls it is like doing a refresh: everything works
> again for a certain amount of time, then, again. It reminds me an
> old version of CFS which used to claim: 'stale NFS file handle'.

"there are no fish in my pond"


# CONFIG_NFS_DIRECTIO is not set

Ive had probs with that option set, disabling did the trick for me.

--=20
left blank, right bald

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHPYkELMyTO8Kj/uQRAhIiAJ93qGt8K0+VWumyGwPZXpA16hKHHQCfU6R9
Mqvk+VECSKBSY4AoNLZRVz8=
=dO1j
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
