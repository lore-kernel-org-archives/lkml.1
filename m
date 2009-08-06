Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbZHFMFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbZHFMFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZHFMFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:05:20 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1174 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZHFMFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:05:19 -0400
Date: Thu, 6 Aug 2009 14:04:51 +0200
From: Erik Mouw <mouw@nl.linux.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>, davem@davemloft.net
Subject: Re: linux-arm-kernel useless for development (was Re: Your message
 to Linux-arm-kernel awaits moderator approval)
Message-ID: <20090806140451.0ef85619@nij0285>
In-Reply-To: <20090806110246.GI31370@elf.ucw.cz>
References: <mailman.3653.1249217530.31043.linux-arm-kernel@lists.arm.linux.org.uk>
	<20090804100051.GA17106@elf.ucw.cz>
	<20090804222840.GC18365@flint.arm.linux.org.uk>
	<20090806100700.GC31370@elf.ucw.cz>
	<20090806104421.GA27773@flint.arm.linux.org.uk>
	<20090806110246.GI31370@elf.ucw.cz>
Organization: Eric Conspiracy Secret Labs
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iFwVz1LlX39+2BAD_jHMg1O";
 protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/iFwVz1LlX39+2BAD_jHMg1O
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 6 Aug 2009 13:02:47 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> On Thu 2009-08-06 11:44:21, Russell King wrote:
>=20
> > It appears the answer to that is no.  People are free to subscribe
> > to the one on vger, where they won't have to "put up" with me.
> > However, it seems that people much prefer to subscribe to my lists,
> > because that seems to be where the expertise is.
> >=20
> > Moreover,
> >=20
> > (a) when ever you have a problem, you go shouting and making public
> > accusations without trying first to resolve the problem in private.
>=20
> When I tried asking in private, I was told to stop complaining or
> loose my mailing list subscription. I'd prefer not to make that
> mistake again.

I can't comment on that one. I have to admit I have been busy (both
private and at work) lately, so I haven't been able to spend as much
time on list maintenance as I would like to.

>=20
> > (c) you really don't understand that "held for moderation" is *not*
> > rejection, but merely a case of mailman spotting something it
> > doesn't like and letting a *human* deal with it rather than
> > out-right rejecting it.
>=20
> For lakml, held for moderation _does_ mean it will return with
> "posting rejected: no reason given" in few days. I have never seen any
> other result, and have got perfectly reasonable messages rejected with
> "no reason". So no, I do not believe there's cooperative human being
> moderating lakml.

That's not true. For every message I reject I always explain the
reason. Most of the time it is "Please subcribe before you're allowed to
post".

> > I wonder, do you even know what happened to the message you're
> > whinging about?  Would you prefer that your message was silently
> > dropped into /dev/null instead of having a chance of the issue
> > being resolved?  It strikes me that _that_ would be a better
> > solution than all your whinging.
>=20
> So... your solution to broken mailing list is to silence everyone who
> complains?

No, if you asked us in private, it would already be solved. I just
increased the max_num_recipients from the default 15 to 30. That should
solve your problem.


Regards,

Erik

--=20
Erik Mouw -- mouw@nl.linux.org
GPG key fingerprint: D6AC 7F15 A26E C5C4 62E0  4A58 FCF9 551C 9B48 B68D

--Sig_/iFwVz1LlX39+2BAD_jHMg1O
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp6xuMACgkQ/PlVHJtIto2gMACeKIwP+nw16my8ep2CZchVFaGN
oLcAnRT3DuuFXsjhCyZmJC0PiMi3C47W
=hCcT
-----END PGP SIGNATURE-----

--Sig_/iFwVz1LlX39+2BAD_jHMg1O--
