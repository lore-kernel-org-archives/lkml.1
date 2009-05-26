Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbZEZKSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbZEZKSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 06:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbZEZKR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 06:17:57 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:52566 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbZEZKR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 06:17:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer;
        b=ER6K9i6X4R+YFCMj3Gk+MO6fZ8wPF3xcWKdQ14nqmqzI8+FIbIruxAUMBmLfux2Yc9
         bJYv9n0pDKDo2oq1OpAgm3CLgO/H9FtAgBFNqLmTAs26PDRPTBBQdt8n2f66dxUEj5Vt
         zV+gEz/sj4wvZ/lo1S9jF08GhkgzM1Kdc/JyM=
Subject: Re: [2.6.27-rc7 vs 2.6.29 Regresion] Wifi Network Slownes rt2500pci
From: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<alejandro.riveira@gmail.com>
Reply-To: alejandro.riveira@gmail.com
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linville@tuxdriver.com,
       Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <200905261058.01039.IvDoorn@gmail.com>
References: <1243247687.5322.8.camel@varda>
	 <200905251323.07845.IvDoorn@gmail.com> <1243255326.6297.53.camel@varda>
	 <200905261058.01039.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-syjqhEbbKVMZzME3+pSQ"
Date: Tue, 26 May 2009 12:17:52 +0200
Message-Id: <1243333072.4888.2.camel@varda>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-syjqhEbbKVMZzME3+pSQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

El mar, 26-05-2009 a las 10:58 +0200, Ivo van Doorn escribi=C3=B3:
> On Monday 25 May 2009, Alejandro Riveira Fern=C3=A1ndez wrote:

> > Would the output of this script[2] for 2.6.29.4 with and without the
> > revert help you ?
>=20
> Yes please try it. but for 2.6.29 you probably need attached script inste=
ad.
> I am not sure if it would produce something useful, because I think Johan=
nes
> assertion is right. With his patch the correct bitmask is send to the dri=
ver
> and the driver actually needs _that_ bitmask without any editing
> (rather then the incorrect one which was send before that patch).

What causes the regression then?

Anyway For the script to work what config options do I need? debugfs?
Anything else ?

>=20
> Ivo
--=20
It's easy to make malloc() return NULL under Windows: there is no fork()=20
system call, and nobody expects the machine to stay up anyway, so who=20
cares? When you say "I wrote a program that crashed Windows", people=20
just stare at you blankly and say "Hey, I got those with the system,=20
*for free*".=20
                                             Linus Torvalds



--=-syjqhEbbKVMZzME3+pSQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esto es una parte de mensaje firmado digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAABAgAGBQJKG8HIAAoJEDO4iEReSTB2VscQAJh9l0PzLrPY4Q2iscypU8bi
XDKOp27KZAGuAdXbL5EwRhuARbSdHP4UZSO4BG/uI2hBLi+8CdVkc5I83aZ6DUVD
hHGQsztw+y6p69uepJILm9PtC9k9psyuRkAa1/okSl+LYUylR7l2S0Eeuo/3JIJ1
cG7IFu8/N0TZFd9IeG1oJ4fs63GYdWTrLSaSk7eHaqirwO2auoKvwUfSpmGWcrlh
GG3upME4ilXaa0lW5rB3L2F0LhXdzsALXmncX6s6eChXjt/NbEnra1Nrr/8mVn44
+V8HgnAh3BLOSsdVFytvmXLrmQs9s0V6wMCk8JHxaz9U82WJVnu0J5vp2v8YxV7W
mV2MguCHFczYi4ANnHM5I/H7aWcoEG5S1fVlwN9j3iMAmYmfAmckgHs+Bq5IAG8q
NgHGFyLR01OIoYUBOlexCJbeOrCZ2P5Y62Klhqt0ixacqDFxelsiGNWUqsjYg9J+
q82Vhg4LLnd8ohGLABZvpNnA1n/hDzR8aieZ+SbWXMQo2dkxW81ymtjoBQZcxKf/
EQn1iDb4tEnUlK+byXZpXLa8tQeRWZVMjtD4D1FheaY2nt6ylT4AMkMN4TX+6z2f
wHGxbluoe/HuQ60QQJ6bqnvT+fZOSq1yVzJWYqIAQ9csF1sMQU3f+s7MkiREPzwT
TV6wBYHawKyILD6EYRxJ
=ZPyf
-----END PGP SIGNATURE-----

--=-syjqhEbbKVMZzME3+pSQ--

