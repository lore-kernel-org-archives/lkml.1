Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab0BFI56 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 03:57:58 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:50744 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab0BFI55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 03:57:57 -0500
X-Spam-ASN: 
Date: Sat, 6 Feb 2010 11:57:43 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: LinuxPPS List <linuxpps@ml.enneenne.com>, linux-kernel@vger.kernel.org,
       "Nikita V\. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su
Subject: Re: [LinuxPPS] [PATCH 4/5] pps: add parallel port PPS signal
 generator
Message-ID: <20100206115743.7cd6f34d@lvk.cs.msu.su>
In-Reply-To: <20100205103914.GE9908@gundam.enneenne.com>
References: <cover.1265228858.git.lasaine@lvk.cs.msu.su>
	<4cea1fe6020a188298922fac15e35e3fefed14ad.1265228858.git.lasaine@lvk.cs.msu.su>
	<20100205103914.GE9908@gundam.enneenne.com>
Organization: LVK
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/PaDqkf/Ad9.M2_YN4kirOiW"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/PaDqkf/Ad9.M2_YN4kirOiW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Rodolfo,

I've accidentally found your email in the archives of linuxpps list.
Very strange that it didn't come to me directly because I was
subscribed...

=D0=92 Fri, 5 Feb 2010 11:39:14 +0100
giometti at enneenne.com (Rodolfo Giometti) =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Wed, Feb 03, 2010 at 11:56:50PM +0300, Alexander Gordeev wrote:
> > Add PPS signal generator which utilizes STROBE pin of a parallel
> > port to send PPS signals. It uses parport abstraction layer and
> > hrtimers to precisely control the signal.
>=20
> What this generators are used for?

This generator sends PPS signals over a parallel port from one computer
to another. So it's just doing what every PPS-capable GPS device does.
I use it to precisely synchronize time on several computers for
distributed real-time simulation. It has very strict timing conditions.



--=20
  Alexander

--Sig_/PaDqkf/Ad9.M2_YN4kirOiW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJLbS8HAAoJEElrwznyooJbfI4H/iNacJizbVbdbVH/K5DfTruj
uVLYBwgkFqAML+Ewbwkb8UKrMCjloyf1+ws7HKCowh3KwvMhVk2jly1+Dalmz6hO
DLkEJuPSAegGQHiiHlnqMKY7RVwzuNl5t+0yNdV9tmCVxjihMN0OTbmcyUyX7Ztc
LzumrqShcX/VXH4at2GcJB4/1QCi3Ul5VY/6S+GH78K8A6X1Zzl7BkNZbWSjV48A
PpudKMDZAEz7i8j+zo2VS687hI1Q08DRNOCMwjIDKCaGfX7Nt9MOaoakTJVm4t3E
bFjGrFB4ZnALiv+LfeBw1zAXT9OLem8FSNmzTG+zC6wBnsMxF2VUP8j9dcNeuww=
=1C1/
-----END PGP SIGNATURE-----

--Sig_/PaDqkf/Ad9.M2_YN4kirOiW--
