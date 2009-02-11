Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbZBKWB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbZBKWB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbZBKWBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:01:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:42624 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZBKWBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:01:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=KaHsGBDtsuc+Sp2RQvcg02DwB6o/KOv2Pb1RJ4yU2ZylZOk8/OcQsJ6CUkwHAvmbWn
         UMqXNZUFd9PpDm1nciXg41BEcq/6AsaJ60BAqjlganHp25odsJdp+NtH68blTun5+/V0
         pxDY/HUCKunrYsASJlcH7aKaxQBDFECbSH0vo=
Date: Wed, 11 Feb 2009 23:01:03 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-02-10-16-35 uploaded (s1d13xfb)
Message-Id: <20090211230103.f2ced59c.kristoffer.ericson@gmail.com>
In-Reply-To: <499303A3.2@oracle.com>
References: <200902110036.n1B0aBZs013975@imap1.linux-foundation.org>
	<499303A3.2@oracle.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_Feb_2009_23_01_03_+0100_8OncVg3yW=p3BeeR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Feb_2009_23_01_03_+0100_8OncVg3yW=p3BeeR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Feb 2009 08:58:11 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-02-10-16-35 has been uploaded to
> >=20
> >    http://userweb.kernel.org/~akpm/mmotm/
> >=20
> > and will soon be available at
> >=20
> >    git://git.zen-sources.org/zen/mmotm.git
> >=20
> > It contains the following patches against 2.6.29-rc4:
>=20
>=20
>=20
> mmotm-2009-0210-1635/drivers/video/s1d13xxxfb.c:57: error: 'S1D13505_PROD=
_ID' undeclared here (not in a function)
> mmotm-2009-0210-1635/drivers/video/s1d13xxxfb.c:58: error: 'S1D13506_PROD=
_ID' undeclared here (not in a function)
> mmotm-2009-0210-1635/drivers/video/s1d13xxxfb.c:59: error: 'S1D13806_PROD=
_ID' undeclared here (not in a function)
> mmotm-2009-0210-1635/drivers/video/s1d13xxxfb.c: In function 's1d13xxxfb_=
probe':
> mmotm-2009-0210-1635/drivers/video/s1d13xxxfb.c:637: error: 'struct s1d13=
xxxfb_par' has no member named 'prod_id'
> mmotm-2009-0210-1635/drivers/video/s1d13xxxfb.c:637: warning: statement w=
ith no effect
> mmotm-2009-0210-1635/drivers/video/s1d13xxxfb.c:638: error: 'struct s1d13=
xxxfb_par' has no member named 'revision'
> mmotm-2009-0210-1635/drivers/video/s1d13xxxfb.c:638: warning: statement w=
ith no effect

Doh! Seems like I left my brain at home. Will drop patch to Andrew right aw=
ay.

>=20
> --=20
> ~Randy


--=20
Kristoffer Ericson <kristoffer.ericson@gmail.com>

--Signature=_Wed__11_Feb_2009_23_01_03_+0100_8OncVg3yW=p3BeeR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmTSp8ACgkQPQls10ERAGdAnQCgu3iELDAlHqMR/SjFd8uGSHDT
lEAAn1IzRzkMdwWyqOMadQOvDoakAjBo
=8UKl
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Feb_2009_23_01_03_+0100_8OncVg3yW=p3BeeR--
