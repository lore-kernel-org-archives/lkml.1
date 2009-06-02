Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbZFBWWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbZFBWWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbZFBWWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:22:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:5208 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbZFBWWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:22:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer;
        b=u91pwB92DFUQx/fMv1/WeAghqHe0nQTGk7BZoA0wL/4gzq+EdmDto8vbMXUIf37fXg
         IZzfLjbCio2jkJ19NucCBZyfERpr4vAmoLcIeQOByLemq7g8y8SWylFWXy0jus4uNsN4
         U0UqKmGWrBwJ0DDkpgA+l59Wx41BJaDc6W9pI=
Subject: Re: [2.6.27-rc7 vs 2.6.29 Regresion] Wifi Network Slownes rt2500pci
From: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<alejandro.riveira@gmail.com>
Reply-To: alejandro.riveira@gmail.com
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linville@tuxdriver.com,
       Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <200906022353.44284.IvDoorn@gmail.com>
References: <1243247687.5322.8.camel@varda>
	 <200906021834.40009.IvDoorn@gmail.com> <1243961465.9894.3.camel@varda>
	 <200906022353.44284.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-bCFE2XwOvKIZa9VjM5t1"
Date: Wed, 03 Jun 2009 00:22:33 +0200
Message-Id: <1243981353.7204.1.camel@varda>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bCFE2XwOvKIZa9VjM5t1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

El mar, 02-06-2009 a las 23:53 +0200, Ivo van Doorn escribi=C3=B3:

> > So my chip works better with incorrect values written in its registers?
>=20
> Apparently, probably because some other register is set to an incorrect v=
alue,
> but I have no idea which one that would be.

Could the fact that i dual boot with windows (and use the windows
driver) have someting to do with it ?

>=20
> > What about other chips out there do they prefer wrong values too ;)
> > Maybe what we thought wrong values are not that wrong ?
>=20
> They are wrong. That exact register initialization is pretty straightforw=
ard
> in the original Ralink driver on which rt2x00 is based.
>=20
> Ivo
--=20
"I contend that we are both atheists. I just believe in one fewer god
than you do. When you understand why you dismiss all the other possible
gods, you will understand why I dismiss yours."
                                                  Stephen Henry Roberts

--=-bCFE2XwOvKIZa9VjM5t1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esto es una parte de mensaje firmado digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAABAgAGBQJKJaYjAAoJEDO4iEReSTB2gdQQAKFSQNzIQ65Aqa/h4alsEGab
8w/QkS5arLgEmbcT4LqDrKuGk9aN1y3K+pAiZiiw+vqQWi5AXLC9+rKl1zFDTSZm
BpgrxWxJ0iGt6STYNQwI6O2pex7KLOjfP9dgwK160zfIY7bEUCHLQXBabJNzpMMf
aG65SAut/xfFgyzukyIl4KIdkiiQgEVavj2AHPVJ8vAKAZ4vkbJCTa3RUl+FtYN7
GT1dRZoZZp2tsfcoKuUtqQqe3Ba91XrWAUV0RP70zGyxD1zQuBFU9EgWjavh8u/5
AFhx0aBysmM7EoXuexXpq1YBkrt/uftgaLSse9cJZn7IZ9aX6IYKTh7Gz0Z+LLYU
T/q78CecpcHAj6XX0T1AY6SNH1C6LcHci1RDIVGQx5uXfRLQgHUKLM2E69f2HnSA
O0vyqzhvAaxkZM0+HGdEA+7s8t2Qh0ZmV9AczZTZ5zUc7UPib9qruWj3PEQRZ84e
ydZfUm/0M2ykryTtyyhnbldYIeGj4/3bcGLjxqlpqH4EraIFzfxs9EDtuWFrTXho
NxJoJWGOteuGMk9U9qE1Uyau5If1Vfd/+MGmxJ2ACDfjxaujDYzp3SCb3oxl1HMn
3iBpd6FpdtG8tS3Soys/rEDEtVrxCY/2CN5d9BrGnHQabYovHaq6snvkmVS04tQ8
Fw3DwrJPRqI+D5lRfhco
=yUq9
-----END PGP SIGNATURE-----

--=-bCFE2XwOvKIZa9VjM5t1--

