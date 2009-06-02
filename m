Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbZFBOBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbZFBOBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbZFBOBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:01:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:38001 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbZFBOBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:01:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer;
        b=XkAzWprQ+W4TGiZcee9BnooeJ8lmNlUijoAQfBsg7PlM84ZrWpoOfkEp2A81REQ/fr
         fo9rFV1xb2gG5+kxg4TZjUZD6Mmq/YFsNg0q2jRKseRD8AM2PPadSxncJaphZ1J/FTaL
         zV32BR7MAYRf2AUV5OvbG9QGIHt+pGVySLz88=
Subject: Re: [2.6.27-rc7 vs 2.6.29 Regresion] Wifi Network Slownes rt2500pci
From: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<alejandro.riveira@gmail.com>
Reply-To: alejandro.riveira@gmail.com
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linville@tuxdriver.com,
       Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1243351397.4888.2.camel@varda>
References: <1243247687.5322.8.camel@varda>
	 <200905261235.36658.IvDoorn@gmail.com> <1243341791.7607.4.camel@varda>
	 <200905261445.46990.IvDoorn@gmail.com>  <1243351397.4888.2.camel@varda>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-D9UvABn7j4IAR34Oo5dI"
Date: Tue, 02 Jun 2009 16:01:32 +0200
Message-Id: <1243951292.22942.1.camel@varda>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-D9UvABn7j4IAR34Oo5dI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

El mar, 26-05-2009 a las 17:23 +0200, Alejandro Riveira Fern=C3=A1ndez
escribi=C3=B3:
> El mar, 26-05-2009 a las 14:45 +0200, Ivo van Doorn escribi=C3=B3:
> > Hi,
> >=20
> [...]
> >=20
> > Ok, that means it is the wrong script, try the other one from the downl=
oad
> > location you previously refered to. I changed the API some time ago, an=
d
> > am not sure which stable release that change will be in.
>=20
> I inline the diff between the two dumps the dumps are attached to the
> mail message

ICMP ECHO REQUEST

Any advance?

> =20
>=20
> --- reg_dump_bad.txt	2009-05-26 17:16:03.078863719 +0200
> +++ reg_dump_good.txt	2009-05-26 16:48:07.654117749 +0200
> @@ -1,4 +1,4 @@
> -kernel: 2.6.29.4-00257-g186f9b1
> +kernel: 2.6.29.4-00258-ga2c0a36
>  driver: rt2500pci
>  version: 2.2.3
>  compiled: May 26 2009 13:05:03
=20
[...]

> Alejandro
--=20
The idea that Bill Gates has appeared like a knight in shining armour to
lead all customers out of a mire of technological chaos neatly ignores
the fact that it was he who, by peddling second-rate technology, led
them into it in the first place.=20
                                     Douglas Adams

--=-D9UvABn7j4IAR34Oo5dI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esto es una parte de mensaje firmado digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAABAgAGBQJKJTC2AAoJEDO4iEReSTB2OSMP/Rlu1gG/gsPSdcRTF8bJ5iSS
djRtbJozFNl2Tx9OnqC1C42CBQk7rigkdnOYWpGSQ+1+LeuIPj5004MbSzePrezL
us2puLJxQ+OsSUhnwXPi6OpuxmQNxkBQxQLCPge/WJ98ZxAKvpprtInUuaMx6dEa
W8FDwgFUZob4VmHvZ6v2XmpF/HQuG+uFJLZf5CdY6xuUFAABBrmel73X1JZXrtVp
nmaJXi4IjX862ahFsIhe7wDY4uimuH+65f0oWJ6Z2XTDsgo0/ujyQOAln0bhgtt6
QIw2FsRxgBhzXNr+7xAzGOkYtUtwY9FxxnJL60UKFMoFAutepwwSViZAdewdVD/n
5H7SMc7eRpGYip1r1fGu6fuZ1xaYv2cVx2SlKsiuRmHQggyT5qCJ5Z9SNxrTA5zw
r06ROV1aZmhaISA5kzHwqUojd8EpbpM81S3DXul++PI/pcLThZ0YhCzHa+zYxbuS
mmaAowKEQHycBeh+gWGppy9ovHiyH4RGsxCHQwNkzygXPcR4CCrJ35XHtIyI793v
UIKW7knQEkcZVmvdVhV0I5i57Rc9pX/QTjpM+M9bHU2vzJKe4MFaWIUnxe4Y+P7g
r32hSBjKQCcsAexX/ddi+DdTG+WrTGYqX5Nzt5254Lc4X5HT+SK/XPiuEMiedvY/
F/q12n6S4t5cpoNTEq2V
=IFrO
-----END PGP SIGNATURE-----

--=-D9UvABn7j4IAR34Oo5dI--

