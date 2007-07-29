Return-Path: <linux-kernel-owner+w=401wt.eu-S933891AbXG2SXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933891AbXG2SXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 14:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764965AbXG2SXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 14:23:40 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:4618 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762983AbXG2SXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 14:23:39 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: ck@vds.kolivas.org
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Date: Sun, 29 Jul 2007 20:23:31 +0200
User-Agent: KMail/1.9.7
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       lkml@metanurb.dk
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707291256.32769.Martin@lichtvoll.de> <20070729174239.GA20399@uranus.ravnborg.org> (sfid-20070729_201124_376072_B6A6B3E0)
In-Reply-To: <20070729174239.GA20399@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1464161.ToqpjMF05p";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707292023.36555.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1464161.ToqpjMF05p
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Sonntag 29 Juli 2007 schrieb Sam Ravnborg:
> On Sun, Jul 29, 2007 at 12:56:28PM +0200, Martin Steigerwald wrote:
> > Am Sonntag 29 Juli 2007 schrieb Sam Ravnborg:
> > > > I
> > > > actually also think that the communication between Ingo and Con
> > > > could have been better especially when Ingo decided to write CFS
> > > > while Con was still working hard on SD.
> > >
> > > You realize that Ingo posted his code for anyone to look at/comment
> > > at about 48 hours after he started to work on CFS?
> >
> > Yes.
>
> So whats wrong then?
> Ingo decides to do a better scheduler - to some extent inspired by
> Con's work. And after 48 hours he publish first version that _anyone_
> can see and comment on. Whats wrong with that?
>
> Did you expect some lengthy discussion before the coding phase started
> or what?
>
> Just trying to understand what you are arguing about.

If I tried to rewrite a kernel subsystem - should I ever happen to dig=20
that deep into kernel matters - while I actually know that someone=20
already spent countless hours on exactly rewriting the exact same=20
subsystem, I think I would have told that other developer about it as=20
soon as I started coding on it. And if it just was a

"Hi Con,

I reconsidered the scheduling ideas again you brought to the Linux kernel=20
world. Instead of using your scheduler tough I like to try to write a new=20
one with fairness in mind, cause I think this, this and this can be=20
improved upon.

I would like to hear your ideas about that as soon as possible and would=20
like you to contribute your ideas and also code, where you see hit. You=20
can find the git / bazaar / whatever repository where I do my=20
developments at: someurl.

Regards, Ingo"

I believe that Ingo did not meant any bad at all. I think its just the way=
=20
he works, he likes to have code before saying anything. But still I=20
believe before I'd go about replacing someone else code completely I=20
would inform that developer beforehand, even if it then turns out not to=20
be feasible at all. No need to anounce it to the world already, but I=20
would have informed that developer.

And aside from that there has been communication before and after this=20
event that IMHO could have been "better". And thats not only targetted at=20
Ingo.

A view this whole issue as "everyone who was involved in it, actually was=20
involved in it and has his share in its outcome". So everyone has a great=20
chance to learn something out of it. (That includes me of course, too.)

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1464161.ToqpjMF05p
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGrNsomRvqrKWZhMcRApmJAKC4hQKSQhVCuhROERXX5MV75PSp2gCgo1WB
h8HF8L664G4FYQtduaCA+bU=
=b2mX
-----END PGP SIGNATURE-----

--nextPart1464161.ToqpjMF05p--
