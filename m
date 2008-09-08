Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbYIHWWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbYIHWWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 18:22:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYIHWVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 18:21:53 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:63441 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYIHWVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 18:21:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer;
        b=CHMP2G4SDcVhdg0tUkCxFFgmMCVWB4hqMRrpPt3oSqkOnG3NhbSuRUbaUBgX2+dH9G
         ZIEd+aAAksnc4YAd4v1lCa2CULZTCWiY336JxbgLMC7EMKzvyawTq51C69cSZAJMYXyQ
         qQ/nriLyE6EUS1MxgQNuRsgoVvUzI6quSD69M=
Subject: Re: Various OOps with 2.6.27-rc5
From: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<alejandro.riveira@gmail.com>
Reply-To: alejandro.riveira@gmail.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080908135736.5d0c3ef8.randy.dunlap@oracle.com>
References: <1220815296.11776.4.camel@Varda>
	 <20080908124641.9ec6887a.randy.dunlap@oracle.com>
	 <1220906182.15312.1.camel@Varda>
	 <20080908135736.5d0c3ef8.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JvhKL1oISBoZgJBUBk5s"
Date: Tue, 09 Sep 2008 00:21:45 +0200
Message-Id: <1220912505.17965.0.camel@Varda>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JvhKL1oISBoZgJBUBk5s
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

El lun, 08-09-2008 a las 13:57 -0700, Randy Dunlap escribi=C3=B3:
> On Mon, 08 Sep 2008 22:36:22 +0200 Alejandro Riveira Fern=C3=A1ndez wrote=
:
>=20
> > El lun, 08-09-2008 a las 12:46 -0700, Randy Dunlap escribi=C3=B3:
> >=20
> > [ ... ]
> > > > The dmesg including oopses
> > >=20
> > > Actually they are INFO: messages with getnstimeofday() being stuck,
> > > similar to a few other reports on lkml.
> >=20
> >  So is it useful to report them or i just do:
> >  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >  And forget about it ??
>=20
> I'm not sure.  I haven't followed the other problem reports very
> closely.  AFAIK, it represents a real bug, but if your system is
> running OK, you could just ignore it...
=20
 Ok; thank you for your time
 Cheers


>=20
>=20
> ---
> ~Randy
> Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
> http://linuxplumbersconf.org/

--=-JvhKL1oISBoZgJBUBk5s
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Esta parte del mensaje =?ISO-8859-1?Q?est=E1?= firmada
	digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEABECAAYFAkjFpXkACgkQ3GEkiSnUSOFQ3QCeIhnfe1AOOqZE/f4dypdbhGWi
BQ8An0tezKyduCRhPaFVqjwwFWqW5dVr
=IkBP
-----END PGP SIGNATURE-----

--=-JvhKL1oISBoZgJBUBk5s--

