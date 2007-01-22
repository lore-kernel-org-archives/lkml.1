Return-Path: <linux-kernel-owner+w=401wt.eu-S932153AbXAVU6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbXAVU6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 15:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932195AbXAVU6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 15:58:36 -0500
Received: from cantor.suse.de ([195.135.220.2]:50701 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169AbXAVU6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 15:58:35 -0500
Date: Mon, 22 Jan 2007 21:58:29 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Alon Bar-Lev <alon.barlev@gmail.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>, tom@dbservice.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 03/26] Dynamic kernel command-line - arm
Message-ID: <20070122205829.GA20248@strauss.suse.de>
Mail-Followup-To: Andrew Morton <akpm@osdl.org>,
	Alon Bar-Lev <alon.barlev@gmail.com>,
	Russell King <rmk+lkml@arm.linux.org.uk>, tom@dbservice.com,
	linux-kernel@vger.kernel.org
References: <20070118125849.441998000@strauss.suse.de> <20070118130028.719472000@strauss.suse.de> <20070118141359.GB31418@flint.arm.linux.org.uk> <45AF92E7.50901@dbservice.com> <20070118152326.GC31418@flint.arm.linux.org.uk> <20070122115650.d0be8bd3.akpm@osdl.org> <9e0cf0bf0701221231sc638114j2f0123650ffc14ea@mail.gmail.com> <20070122124442.9eed5fd9.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <20070122124442.9eed5fd9.akpm@osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Andrew Morton <akpm@osdl.org> [2007-01-22 21:44]:
>=20
> > Some general comments... or should I CC other people etc...
> > I submitted this several times but got almost no architecture to ACK.
> >=20
> > I just don't know how we can progress with this issue... All we wanted
> > is to break the 256 limit in x86...
>=20
> yes, the patches looked reasonable-looking.  But iirc they were against
> 2.6.19 which is prehistoric.  Please redo and resend against a development
> kernel.

I refreshed the patches from Alon against 2.6.20-rc4-mm1. Or was I
totally wrong?



Regards,
Bernhard
--=20
SUSE LINUX Products GmbH                E-Mail:  bwalle@suse.de
Maxfeldstr. 5                           Phone:   +49 (911) 74053-0
90409 N=FCrnberg, Germany
OpenPGP DDAF6454: F61F 34CC 09CA FB82 C9F6  BA4B 8865 3696 DDAF 6454

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFtSV1iGU2lt2vZFQRAgNTAKCuMN0r/EP+8YzWCAGmV9+8Osi73ACfUY9q
rh3+yjfHM8J/LaFJuL8erJU=
=WRSc
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
