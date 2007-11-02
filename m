Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbXKBMx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbXKBMx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 08:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbXKBMxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 08:53:20 -0400
Received: from mail.lysator.liu.se ([130.236.254.3]:58683 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbXKBMxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 08:53:19 -0400
X-Greylist: delayed 1282 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Nov 2007 08:53:19 EDT
In-Reply-To: <335463.37228.qm@web8414.mail.in.yahoo.com>
References: <335463.37228.qm@web8414.mail.in.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-1-951137529"
Message-Id: <CD4B7E02-9995-4496-8031-4804E268B9D6@27m.se>
Cc: uclibc@uclibc.org, linux-mips <linux-mips@linux-mips.org>,
       "linux-kernel.org" <linux-kernel@vger.kernel.org>, buildroot@uclibc.org
Content-Transfer-Encoding: 7bit
From: Markus Gothe <markus.gothe@27m.se>
Subject: Re: NPTL support
Date: Fri, 2 Nov 2007 13:31:41 +0100
To: veerasena reddy <veerasena_b@yahoo.co.in>
X-Pgp-Agent: GPGMail 1.1.2 (Tiger)
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-1-951137529
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed

You'll have to use the uClibc-nptl branch on their svn. In 0.9.28, no.

//Markus

On 2 Nov 2007, at 06:03, veerasena reddy wrote:

> Hi,
>
> I am trying to build the toolchain for MIPS processor using buildroot.
> I am using gcc version of 3.4.3, binutils-2.15, uclibc-0.9.28 and =20
> linux-2.6.18.8 kernel.
>
> Basically i need to enable NPTL feature support in my toolchain.
> does uclibc-0.9.28 has the support for NPTL?
> If not, how can i get it enabled for my above build configuration?
>
> I see there is separate branch "uclibc-nptl" in uclibc.
> Do i need to use this (uclibc-nptl) to meet my requirement?
>
> Could you please suggest me right approach to succssfully enable NPTL?
>
> Thanks in advance.
>
> Regards,
> Veerasena.
>
>
>       Why delete messages? Unlimited storage is just a click away. =20
> Go to http://help.yahoo.com/l/in/yahoo/mail/yahoomail/tools/=20
> tools-08.html
>
>

_______________________________________

Mr Markus Gothe
Software Engineer

Phone: +46 (0)13 21 81 20 (ext. 1046)
Fax: +46 (0)13 21 21 15
Mobile: +46 (0)73 718 72 80
Diskettgatan 11, SE-583 35 Link=F6ping, Sweden
www.27m.com



--Apple-Mail-1-951137529
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)

iD8DBQFHKxiu6I0XmJx2NrwRAmL9AKC+UJvmi+faIw8jv2mTgX02lQ0SVQCgojMj
eb6d+5dvclZWIzioxljUx9A=
=PoSc
-----END PGP SIGNATURE-----

--Apple-Mail-1-951137529--
