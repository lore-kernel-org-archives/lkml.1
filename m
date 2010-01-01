Return-Path: <linux-kernel-owner+w=401wt.eu-S1752227Ab0AAXcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab0AAXcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 18:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360Ab0AAXcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 18:32:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:34044 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab0AAXcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 18:32:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=O25+UOVbIMM8Rt0p6RslJrqXAQfWxevjmIKvrBc+BSniiSLw7+fsixx7sAWljP3eYs
         VJvaETdnLGYdMIb35nLGEPijvrL2B/0vbCWKNYrQ6o3AOOR3dGafBQj4SeYpaomNL4I8
         Ncvo/wBdm8yf3DNp8fp9XrbCcTBDlZFSIxDeo=
Date: Sat, 2 Jan 2010 01:33:23 +0200
From: Sergei Trofimovich <slyich@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [Bug #14935] hd-audio0 eats 25% CPU (according to top)
Message-ID: <20100102013323.3651b95a@mosly>
In-Reply-To: <NJVdobuNFNK.A.wuG.KnhOLB@chimera>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
 <NJVdobuNFNK.A.wuG.KnhOLB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/G5tb_Pbb/wT4H+h9cKLyFf."; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/G5tb_Pbb/wT4H+h9cKLyFf.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Dec 2009 16:10:01 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
>=20
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
>=20
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14935
> Subject		: hd-audio0 eats 25% CPU (according to top)
> Submitter	: Sergei Trofimovich <slyich@gmail.com>
> Date		: 2009-12-25 10:21 (5 days old)
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D126173644210280&w=3D4
> Handled-By	: Takashi Iwai <tiwai@suse.de>
> Patch		: http://patchwork.kernel.org/patch/69747/

Merged upstream as: 729d55ba972348234759f8e40abf8de020f0d505 (aka v2.6.33-r=
c2-2-g729d55b)
I've tested v2.6.33-rc2-249-gcd6e125 and it fixes problem.
--=20

  Sergei

--Sig_/G5tb_Pbb/wT4H+h9cKLyFf.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAks+hkcACgkQcaHudmEf86rBegCfduZdjnhc2R8hR2YU+HMsggih
KLkAn3lmgomogJuGm1R7QSx1W7d1tXCJ
=sXcJ
-----END PGP SIGNATURE-----

--Sig_/G5tb_Pbb/wT4H+h9cKLyFf.--
