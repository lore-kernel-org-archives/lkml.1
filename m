Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZHCWOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZHCWOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 18:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZHCWOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 18:14:11 -0400
Received: from mail.open.by ([193.232.92.17]:55907 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbZHCWOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 18:14:10 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 9235 [Aug 3 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Tue, 4 Aug 2009 01:16:51 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] proper tty-ldisc refcounting (was Re: WARNING at:
 drivers/char/tty_ldisc.c)
Message-ID: <20090803221651.GA3122@localdomain.by>
References: <20090802120120.GA3097@localdomain.by>
 <alpine.LFD.2.01.0908020940530.3352@localhost.localdomain>
 <20090802190514.GA3278@localdomain.by>
 <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain>
 <87k51l9apo.fsf@devron.myhome.or.jp>
 <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain>
 <20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain>
 <alpine.LFD.2.01.0908031047010.3208@localhost.localdomain>
 <20090803181811.GA15848@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <20090803181811.GA15848@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/03/09 11:18), Greg KH wrote:
> Ok, I'll queue them up if they pass Sergey's testing.
>=20

I've been away. Sorry.
Will test ASAP.

	Sergey

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkp3YdMACgkQfKHnntdSXjTxXQP9Hk8naW8HGyMcDq8Ad4zVwAUS
OLEu7U7FqG5WUmXCjtC+QGgXdAaQWLYYjc1TSS0MDSHqpHS/YWwtGobL8/QQwplI
iz3Y4Zqz3owd1/yjrTZI+pYbQ/EUh5EnbbLua/4qc1kTQ5+rDIIj0J//PkHJvqsV
6MitBLkIdJ4x48iqk1g=
=jT5P
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
