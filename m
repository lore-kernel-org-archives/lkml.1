Return-Path: <linux-kernel-owner+w=401wt.eu-S1761413AbXG2JE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761413AbXG2JE6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 05:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760707AbXG2JEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 05:04:49 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:3172 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbXG2JEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 05:04:42 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: ck@vds.kolivas.org
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Date: Sun, 29 Jul 2007 11:04:33 +0200
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       lkml@metanurb.dk
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <Pine.LNX.4.64.0707281927500.15125@fbirervta.pbzchgretzou.qr> <alpine.LFD.0.999.0707281050590.3442@woody.linux-foundation.org> (sfid-20070729_101032_902278_7E626EF8)
In-Reply-To: <alpine.LFD.0.999.0707281050590.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1555556.WuYB3rUxzR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707291104.39945.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1555556.WuYB3rUxzR
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Samstag 28 Juli 2007 schrieb Linus Torvalds:
> On Sat, 28 Jul 2007, Jan Engelhardt wrote:
> > You cannot please everybody in the scheduler question, that is clear,
> > then why not offer dedicated scheduling alternatives (plugsched comes
> > to mind) and let them choose what pleases them most, and handles
> > their workload best?

[...]

> So I personally think that it's much better to find a setup that works
> "well enough" for people, without having modal behaviour. People
> complain and gripe now, but what people seem to be missing is that it's
> a journey, not an end-of-the-line destination. We haven't had a single
> release kernel with the new scheduler yet, so the only people who have
> tried it are either
>
>  (a) interested in schedulers in the first place (which I think is
> *not* a good subset, because they have very specific expectations of
> what is right and what is wrong, and they come into the whole thing
> with that mental baggage)
>
>  (b) people who test -rc1 kernels (I love you guys, but sadly, you're
> not nearly as common as I'd like ;)
>
> so the fact is, we'll find out more information about where CFS falls
> down, and where it does well,  and we'll be able to *fix* it and tweak
> it.

I have nothing against CFS in the kernel. I had as long as my ThinkPad T23=
=20
had interruptions in music playback initially even though the machine was=20
idling - while at the same time music playback was perfectly fine with SD=20
since quite some iterations. After quite some iterations of testing new=20
CFS versions from Ingo it started working like I think it should.=20

Expecting a interruption free music playback IMO by no way is any mental=20
baggage. I for sure am interested in schedulers, but actually I do not=20
understand the exact principles by with SD and CFS work, I just had no=20
time to look at them closer, and thus just looked at: How does it behave=20
on my laptops with different desktop loads? Actually from a technical=20
point of view I do not care whether CFS or SD goes in, cause I simply=20
understand enough of the technical concepts behind them. And since they=20
are behaving roughly the same on my laptops now I have no issue with CFS=20
going in from a functional view. It seems to do what I expect from a=20
scheduler and I am happy with that.

While I have nothing against CFS in the kernel, I actually do not like the=
=20
way the decision was done and how it was communicated. Its not the=20
outcome of the decision but the way it was done that bothers me. I=20
actually also think that the communication between Ingo and Con could=20
have been better especially when Ingo decided to write CFS while Con was=20
still working hard on SD.

I do think that it would not have been necessary to loose Con's talent.=20
Sure I think that Con had its share in it, but it does not make sense to=20
concentrate on his share, cause only he can do that and he is gone for=20
now. But thats exactly what I perceive you are doing.=20

And I realize it doesn't make sense for me at all to concentrate at your=20
or Ingo's share. I made my point and unless you Ingo and the others=20
involved decide to look at whether there might be something you have done=20
that has contributed to loosing the talent of a good kernel developer the=20
issue can't be helped. Unless people decide to look at themselves instead=20
of pointing out what in their eyes has been wrong with others, the issue=20
will stand still.

I am pretty confident that SD in the kernel would have been a viable=20
choice as well and that Con would have done his best to support and=20
maintain it. Well now thats history. Con decided to stay out of kernel=20
development and I actually can understand him.

I believe it is possible to learn something out of how this all happened.=20
And actually I merely wanted to point this out to you. Whether you decide=20
to learn something out of it or not, actually is your choice.=20

Regards,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1555556.WuYB3rUxzR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGrFgnmRvqrKWZhMcRAh9bAKCoaiVNPvwx1PTsDEyjCLfHjeJZgQCgnOmo
+eFIByWUF7k3SbDYk2gPVLg=
=EP1/
-----END PGP SIGNATURE-----

--nextPart1555556.WuYB3rUxzR--
