Return-Path: <linux-kernel-owner+w=401wt.eu-S1423228AbXDYG0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423228AbXDYG0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 02:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423229AbXDYG0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 02:26:35 -0400
Received: from attic.omnifarious.org ([216.254.16.17]:52557 "EHLO
	attic.omnifarious.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423228AbXDYG0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 02:26:34 -0400
Subject: Re: Question about Reiser4
From: "Eric M. Hopper" <hopper@omnifarious.org>
To: lkml777@123mail.org
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <1177459922.31000.1186391425@webmail.messagingengine.com>
References: <20070423111939.c876c9cc.akpm@linux-foundation.org>
	 <462E17AF.7090604@namesys.com>
	 <1177459922.31000.1186391425@webmail.messagingengine.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9MJw0jQzCktsrPZBMn3j"
Organization: Omnifarious Software
Date: Tue, 24 Apr 2007 23:26:31 -0700
Message-Id: <1177482391.3315.20.camel@bats.omnifarious.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9MJw0jQzCktsrPZBMn3j
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-04-24 at 17:12 -0700, lkml777@123mail.org wrote:
> On Sun, 22 Apr 2007 19:00:46 -0700, "Eric Hopper"
> > <hopper@omnifarious.org> said:
>=20
> > I did.  That whole thread is some guy spouting off a ludicrous Bonnie++
> > benchmark showing that compressing long strings of 0s results in things
> > taking up very little space and being very fast.
>=20
> I think you are deliberately being stupid here.
>=20
> You are claiming that REISER4's good speed results when using
> compression actually has a simple explanation and THEREFORE all good
> result for the filesystem, even those results that have nothing to do
> with compression, are negated.

I am claiming nothing of the sort.  You are assuming that I'm claiming
this for some random reason.  And in so doing, you are hurting your
cause and mine.

If you would bother to read, I really like the ideas in Reiser4, and I
definitely think it has distinct performance advantages in some much
more common situations than the highly flawed benchmark with Bonnie++
and compression.  I would like it included in the mainline kernel.  In
arguing with me, you are arguing against someone who (as far as I can
tell) you actually share a cause with.

But, bringing in benchmarks that have serious flaws as a general
use-case and attempting to use them as an argument does way more to hurt
your cause than help.  It brands you as a crackpot and a crank (note
that I am not calling you either of those things) and that impression
will also bleed off onto all those who share an association with you by
way of sharing some of your opinions.

Additionally, repeatedly posting something everybody has already read
and ranting about how everybody is ignoring all the good parts of it and
focusing on the bad parts makes things even worse.

I will not respond to you again.  Please stop jumping into discussions
about Reiser4.  I would like it included in the mainline kernel, and you
are hurting that cause.

--=20
Eric Hopper (hopper@omnifarious.org  http://www.omnifarious.org/~hopper/)

--=-9MJw0jQzCktsrPZBMn3j
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP MESSAGE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGLvSXjtsvlOwvazYRAkfCAJwIFYBqet3ZUBlPf1rb2X8yMiznjACghUI7
IgBHAIUvi48J5hrESknTYjM=
=9lS/
-----END PGP MESSAGE-----

--=-9MJw0jQzCktsrPZBMn3j--
