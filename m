Return-Path: <linux-kernel-owner+w=401wt.eu-S1760859AbXK1NiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760859AbXK1NiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 08:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757353AbXK1NiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 08:38:11 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:3243 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbXK1NiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 08:38:10 -0500
Message-ID: <474D6F3A.6020906@imap.cc>
Date: Wed, 28 Nov 2007 14:38:02 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: git guidance
References: <474C9B31.8000408@imap.cc> <20071127235511.bd9557f0.Kristoffer.ericson@gmail.com> <20071127235237.GF15227@1wt.eu>
In-Reply-To: <20071127235237.GF15227@1wt.eu>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig34050CF4EEDDAFC97865DF20"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig34050CF4EEDDAFC97865DF20
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Willy,

thanks for your kind answer.

Am Mi 28 Nov 2007 00:52:38 +0100, Willy Tarreau schrieb:
> Tilman, there was a howto by Jeff Garzik I believe.

Yes, I started from that and it's fine as far as it goes. The
"Everyday GIT With 20 Commands Or So" document was quite helpful
too, especially the section "Individual Developer (Participant)".
But they don't quite cover my workflow yet.

> The tutorials
> on the GIT site are quite good too. You must read them entirely and
> proceed with the examples as you read them. Believe me, it helps you
> understand a lot of things, specially about the split in 3 parts
> (objects, cache, and working dir).

I think I got that part. My questions concern practical things
like when to make a new branch, how to resubmit a patch following
post-commit changes, what to do when "git format-patch" doesn't
produce the desired result or when "git pull" obstinately declares
"Already up-to-date" even though I know that isn't true, how to
track a patch after submission to LKML to see when or whether it
appears in the main tree, or how to scrub the history to stop
"git log origin..HEAD" from listing (and "git format-patch" from
formatting) long-merged changes as new. Well, I'll take that up on
the git@vger.kernel.org list then, as proposed by J. Bruce Fields,
in order not to annoy LKML readers any longer.

> Anyway, don't get demotivated about the tool or the workflow. If
> you find it inconvenient to use, you're doing something wrong and
> you don't know it.

That's what I'm thinking. What I'm trying to do can't be that
different from what all those happy git users are doing. I guess
if I could just watch an experienced git user at work for a day
most of my problems would vanish.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Yes, I have searched Google!


--------------enig34050CF4EEDDAFC97865DF20
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHTW87Q3+did9BuFsRAvvsAJ92q7WATHVT7TD/PY4axnVHzQGoyACdFpP0
lzxyuiAVsCovN7iiQZvlMWU=
=MG2B
-----END PGP SIGNATURE-----

--------------enig34050CF4EEDDAFC97865DF20--
