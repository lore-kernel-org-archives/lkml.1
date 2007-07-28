Return-Path: <linux-kernel-owner+w=401wt.eu-S1757398AbXG1KbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbXG1KbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 06:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbXG1KbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 06:31:10 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:3256 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbXG1KbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 06:31:08 -0400
X-Greylist: delayed 1555 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jul 2007 06:31:08 EDT
From: Martin Steigerwald <Martin@lichtvoll.de>
To: ck@vds.kolivas.org
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Date: Sat, 28 Jul 2007 12:05:10 +0200
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185588279.1654.1.camel@localhost> <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org> (sfid-20070728_101007_531837_EA6AB2C7)
In-Reply-To: <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5949748.SGI2Qe3VAN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707281205.10871.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5949748.SGI2Qe3VAN
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Samstag 28 Juli 2007 schrieb Linus Torvalds:
> On Sat, 28 Jul 2007, Kasper Sandberg wrote:
> > Im still not so keen about this, Ingo never did get CFS to match SD
> > in smoothness for 3d applications, where my test subjects are
> > quake(s), world of warcraft via wine, unreal tournament 2004. And
> > this is despite many patches he sent me to try and tweak it.

[...]

> I'm happy that SD was perfect for you. It wasn't for others, and it had
> nobody who was even interested in trying to solve those issues.

Linus, I seen somethimg *completely* different on the CK mailinglist. Con=20
Koliva worked up to his limits and likely beyond them to fix any and all=20
issues reported. Heck, he maintained that thing out of the kernel tree=20
for a long time and the version number 1.0 does not come from nothing, it=20
has gone through at least 50 iterations.

The only thing I know of where Con did not want to "fix" a problem, was=20
with renicing X, cause he didn't want to introduce a special case in the=20
scheduler, where a simple nice would do the trick. That said I never saw=20
serious problems with X unreniced at all.

So I think your statements here are simply not accurate and also not fair,=
=20
cause I have the impression that you did not look carefully before=20
writing them.

You speak about working together, but now I ask you: Did you ever have a=20
personal word with Con, did you ever tell him that you don't trust that=20
he can maintain the SD scheduler when its mainline? Did you ever outspoke=20
your concerns to *him*?

Granted, from a health point of view and maybe also from looking at how=20
much time a maintainer will be able to spend more time on the scheduler=20
Ingo *may* can do more than Con - if he doesn't do too much else;-). But=20
looking at personal committment actually I saw no difference between Con=20
and Ingo.

So while it may be good that CFS went in from that point of view, the way=20
the decision was made was very suitable to piss off a very talented=20
developer.

Anyway, the decision is done, Con resigned already, he gave up on it. And=20
actually when I read your mail I can understand why he did so[1]. Sure,=20
he is involved as well and I think he felt hurt on some things that in my=20
perception were meant neutral or even supporting and postive, but still I=20
disagree a lot on the tone in LKML and understand exactly why Linux=20
users, Linux desktop users away from it as much as they can. Actually I=20
do not get that as you state in one of your latest interviews that you=20
are actually very interested into the desktop, cause its a very suitable=20
kernel test case[2].

Well I for sure will patch whatever into my kernels that I think should be=
=20
in there for me to have a *pleasant* desktop experience, including, but=20
not limited to, TuxOnIce ;-). Oh, but that might possibly not be mainted=20
nicely enough as well then. (Yes, here is sarcastic irony, lots of it. So=20
no offence intended, Nigel;-)


[1] http://apcmag.com/6735/interview_con_kolivas
[2] http://www.oneopensource.it/interview-linus-torvalds/


Regards,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart5949748.SGI2Qe3VAN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGqxTWmRvqrKWZhMcRAuiAAJ0ZUoUvSJuOeX0nzeN9XsY8rolLgwCfb0o/
m6qInzim5Y16RFGhursYUb4=
=vCfF
-----END PGP SIGNATURE-----

--nextPart5949748.SGI2Qe3VAN--
