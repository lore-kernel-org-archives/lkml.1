Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360Ab0BGK2H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 05:28:07 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:39991 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab0BGK2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 05:28:05 -0500
Date: Sun, 7 Feb 2010 11:26:58 +0100
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [00/74] 2.6.32.8-stable review
Message-ID: <20100207102658.GA24865@develbox.linuxbox.cz>
References: <20100204171850.GA16539@kroah.com>
 <20100205073659.GD31093@develbox.linuxbox.cz>
 <20100205171250.GC14145@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <20100205171250.GC14145@suse.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Milter-Copy-Status: I
X-Antivirus: on proxybox by Kaspersky antivirus, engine 5.5.10, data 3221735 records(07-02-2010)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

yup, I just tried and it works well. thanks!
nik


On Fri, Feb 05, 2010 at 09:12:50AM -0800, Greg KH wrote:
> On Fri, Feb 05, 2010 at 08:36:59AM +0100, Nikola Ciprich wrote:
> > Hi Greg,
> > just tried it, and it crashes during boot.
> > Previous 2.6.32.x versions were OK.
> > here is the screen:
> > http://nelide.cz/downloads/2.6.32.8-crash.png
> > sorry if it's a bit crude, but I'm leaving for 4 days vacation,
> > so I'm in a bit of hurry :)
> > On Tuesday, I can provide more testing/whatever if needed.
>=20
> Can you try the -rc2 release I just made if you get a chance?  It should
> resolve this issue.
>=20
> thanks,
>=20
> greg k-h
>=20

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFLbpVy3xdJJrLygV4RArOkAKCgtlQ3TaWPgnGaFfrPor4iaHQiJwCg38Lu
RpchiBz+3hiAxQ6A4yTqTxA=
=4+xO
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
