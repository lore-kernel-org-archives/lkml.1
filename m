Return-Path: <linux-kernel-owner+w=401wt.eu-S1752273AbZDMW3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbZDMW3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZDMW2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:28:48 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:44550 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbZDMW2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:28:47 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Subject: Re: [RFC][patch] filesystem: Vmufat filesystem, version 4
Date: Mon, 13 Apr 2009 18:28:43 -0400
User-Agent: KMail/1.11.1 (Linux/2.6.28; KDE/4.2.1; x86_64; ; )
Cc: Paul Mundt <lethal@linux-sh.org>,
       "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-sh" <linux-sh@vger.kernel.org>,
       "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>,
       Sam Ravnborg <sam@ravnborg.org>
References: <1239654768.6542.10.camel@localhost.localdomain> <1239658604.6542.28.camel@localhost.localdomain> <1239658843.6542.30.camel@localhost.localdomain>
In-Reply-To: <1239658843.6542.30.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5691143.QjW6X3utMt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200904131828.45729.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5691143.QjW6X3utMt
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 13 April 2009 17:40:43 Adrian McMenamin wrote:
> Should any earlier reviewer want to see what changes I've made please
> have a look here:
>
> http://newgolddream.dyndns.info/cgi-bin/gitweb.cgi
>
> Hopefully that will make the changes from earlier versions a bit
> clearer.

if the changelog history is clean, then you could always ask for people to=
=20
pull the whole history rather than the final diff between mainline.  that's=
 =20
actually kind of preferred as it implicitly retains some of the logic behin=
d=20
decisions made and other ideas tried.
=2Dmike

--nextPart5691143.QjW6X3utMt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJJ47ydAAoJEEFjO5/oN/WBrM4P/jIqmfm5RmbKfHrnaWGe0J4p
9ULJk5SF1eNhzkrcnmeHFaCJ4++AjBPOSJDxo2++YBxknr8e6WijnDp99+3/CQFO
X/JuRdsJBvOhvR0cd5i+qFjFAVp4k5Tf1z1IC5pDLRodOemRVZShZzuGFWCe0bGu
bfkqbpvG5CHtS1qKef6UdRU1CZhxW/hJIuYqJom7hXtw+cpkLYKMJKMOMVbrIh5O
UD47/toPbi6tYm39YFZjr3x/njdLKj/bh27kEry4bXd6dA0KnBs+9IA7Xz0BOrgt
fKJPmEX8qZuFHxyUH0cOVKhDhjjDT3cUa7dW0qxhjKK0u/4nX2GTuW6JVtiXrWPk
1dMnjCcOiEWpqXfCjkptoko7RHBmbcma1rEyQnLDazde/MCiyVjgf+0ZKWpXouQl
PTn4ZZP3Ny0Lozz75UV7NayTGRKw+yuU+IrEgpHKIao7IB9vsb79JLqNqBu1iEln
i8lzZtmL7BDHgdn4wBSVJM440CNPn+VrtfPO5enOjDOFSV8q2THzmrBC6+3Upmqs
zEfG1Q/b2h1LdShYzrM2fDiid1plxyiUmqp4gUmiuKM6w/RMzn2+9yBSLsncLo3o
yT6P8s0byMOzfiou2ZT/BPOumjok1d0QEdKsA96eIGZgZRVYBxrmUdbf7ogH1ICb
IhobeIryvWTPIml6E29O
=eOVW
-----END PGP SIGNATURE-----

--nextPart5691143.QjW6X3utMt--
