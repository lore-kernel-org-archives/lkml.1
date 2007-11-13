Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbXKMMgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbXKMMgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 07:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbXKMMg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 07:36:26 -0500
Received: from chello089077114002.chello.pl ([89.77.114.2]:41313 "EHLO
	astralstorm.puszkin.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbXKMMgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:36:25 -0500
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Nov 2007 07:36:24 EST
Date: Tue, 13 Nov 2007 13:28:47 +0100
From: Radoslaw Szkodzinski (AstralStorm) <lkml@astralstorm.puszkin.org>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [poll] Is the megafreeze development model broken?
Message-ID: <20071113132847.555e6c84@astralstorm.puszkin.org>
In-Reply-To: <slrnfjh4o1.c8q.tuomov@jolt.modeemi.cs.tut.fi>
References: <fgtfqa$h9j$1@ger.gmane.org>
	<m1sl3b4t5k.fsf@ebiederm.dsl.xmission.com>
	<slrnfjgmit.l07.tuomov@jolt.modeemi.cs.tut.fi>
	<20071112152057.GJ9771@stusta.de>
	<20071112160254.GA31972@jolt.modeemi.cs.tut.fi>
	<47388F5A.20206@smsglobal.net>
	<slrnfjh4o1.c8q.tuomov@jolt.modeemi.cs.tut.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/DYJbtYBVf/eWf1qCj7LtJVh";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/DYJbtYBVf/eWf1qCj7LtJVh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Nov 2007 17:53:06 +0000 (UTC)
Tuomo Valkonen <tuomov@iki.fi> wrote:

> The complement of "open source" is not closed source, or at least
> "source not available". (And I doubt it's even illegal to look at
> source you have somehow got.) It includes so-called license-free=20
> or license-less software [1] as well -- something I'm likely to do
> with any of my future work, if I release the source at all.

The only problem with djb's scheme is that you cannot mirror the software u=
nless given permission from the author. No, not even unmodified source.

And in some (weird) parts of the world, all rights are reserved by default.=
 Not just distribution rights, also use rights. So you have to spell it out=
 that you allow people to use the software unconditionally. There's no need=
 to disclaim warranty if you don't expect to ever be sued. (anyway, it's no=
t sold, so most warranty rights don't apply)

Disclaimer: IANAL.

> It's been a constant downfall ever since I started using Linux in '95
> or so. None of the gripes I had then have been fixed (the bloatware
> known as the X server is still allowed to hang the system), and many=20
> other things have been turned into crap, largely due to world domination
> plans. (See the "idiot box Linux" link in one of the recent posts.)

Everybody knows the story of X server development model, which has been ver=
y ineffective until recent xorg-x11 developments. It's just been 3 releases=
 (7.0 and 7.1 count as one) since X.org took over. Cut it some slack just y=
et, please.

Certain commercial X servers are nice and lightweight. Go buy a licence if =
you hate X.org distribution. Oh, it doesn't have the drivers you need? Toug=
h luck.
Pay your hardware developer and/or the company.

Any system that doesn't have the same user base as Windows or enough money =
to bribe  major hardware players will suffer the same problem.
(Apple can pay some for drivers)

BTW, why don't we see graphic systems other than X in the FOSS market?
All such projects I can recall failed: Y-Windows, Fresco...

Only Apple had enough manpower to implement its own replacement (Quartz), a=
nd they were in a better place: they were writing a system from scratch, wi=
th almost no concerns about backwards compatibility.

So, in order to start an X replacement, you have to write an operating syst=
em around it...

> Indeed, Microsoft is offering the only alternative to the suffocating
> monoculturist hegemony promoted by the major FOSS projects. (OS X
> is too much like Gnome.)

Huh? It is the Microsoft that is the monoculture.
They supply one true GUI with scarce documentation, a package of bundled so=
ftware and libraries (including C library), one true media system (DirectSh=
ow) and one true configuration system - registry. And also an internet brow=
ser.
Recently the suite has been expanded with .NET runtime.

Guess what - these mostly (uhm...) work fine.

The about only difference is that people (developers external to Microsoft)=
 bundle software with the dependencies.

I wonder why almost no distributions do that...

You can install multiple versions of the same package... it requires modera=
te amount of work, nothing a medium-size distribution can't handle. (e.g. s=
ome Linux-From-Scratch installation methods and GoboLinux support multiple =
installations of the same package)
Just some build system patches for certain software.

Oh, you want to get everything with no work on your part? Go ask your vendo=
r... that is, upstream.

BTW, good flame bait.

>   [1]: http://www.thedjbway.org/license_free.html

Footnotes have no place in emails. Theye are not books.

--Sig_/DYJbtYBVf/eWf1qCj7LtJVh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQFHOZiFBlhXA0ALOYMRAml+AJsGwvrxthRI276Ijter5Kblay3LvQCfdsJw
PYM6TBsez8r2EZT+cDBDRaE=
=3tEq
-----END PGP SIGNATURE-----

--Sig_/DYJbtYBVf/eWf1qCj7LtJVh--
