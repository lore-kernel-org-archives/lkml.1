Return-Path: <linux-kernel-owner+w=401wt.eu-S1752636AbXE3JGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbXE3JGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 05:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbXE3JGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 05:06:23 -0400
Received: from team.teamix.net ([194.150.191.72]:36936 "EHLO rproxy.teamix.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750803AbXE3JGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 05:06:23 -0400
X-Greylist: delayed 1929 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 May 2007 05:06:22 EDT
From: Martin Steigerwald <ms@teamix.de>
Organization: team(ix) GmbH
To: ck@vds.kolivas.org
Subject: Re: [ck] Mainline plans
Date: Wed, 30 May 2007 10:33:53 +0200
User-Agent: KMail/1.9.5
References: <200705292130.57072.kernel@kolivas.org> <200705311138.11935.kernel@kolivas.org> (sfid-20070530_083908_421282_98F50744)
In-Reply-To: <200705311138.11935.kernel@kolivas.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1215186.ADDR7nir21";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705301034.04703.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1215186.ADDR7nir21
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Donnerstag, 31. Mai 2007 03:38 schrieb Con Kolivas:
> On Tuesday 29 May 2007 21:30, Con Kolivas wrote:

> Again, as usual, I'm' frustrated. If cfs has yet to beat SD, why should
> mainline go with cfs? Ingo said to me offlist that the scheduler that
> performs the required task the best was what should go into mainline. I b=
et
> a million bucks that given Linus has given the go-ahead for cfs into
> mainline that he won't turn around and say "but wait, SD still has lots of
> case reports of better behaviour", so we should go with that. This is kin=
da
> funny I have to say. Ingo, I know you're reading, and no I don't believe
> there is evidence CFS is better in real world workloads yet. Sure, there's
> other issues of maintainability, code understanding and blah blah that
> you'll pull out as reasons cfs' superiority. Of course, performance is the
> ultimate judge, BUT as I said, I'm over it, mainline has caused me far too
> much pain anyway. .

Hi Con!

Maybe reports about scheduler tests and feedback should by default go to th=
is=20
mailing list *and* the kernel mailinglist.

I bet that Linus doesn't read this list and thus misses most of the favorab=
le=20
reports for SD.

I am using 2.6.21-ck2 everywhere now and I am really happy.

I did not test recent CFS, but Ingo asked me do to it with my Amarok machin=
e,=20
to test for regressions since introduction of increased 3D performance. In =
my=20
last tests SD and CFS behaved quite equivalent to one another - that was wi=
th=20
CFS-v11. If CFS-v14 has not regressed, it would work for me as well.

But I also appreciate the other enhancements in ck patchset and I would lik=
e=20
to have as much as possible of it into mainline.

Actually I think the decision on which scheduler to put into mainline shoul=
d=20
depend on its technical merits and the user feedback.

Regards,
=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart1215186.ADDR7nir21
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGXTb8HhDFkwOZrpARAusLAJ9WIPTHwYoudKbgXTZtpZz2IGGOyACfbPwW
/WdsV42W0gox69nvPQCtcLM=
=sMJy
-----END PGP SIGNATURE-----

--nextPart1215186.ADDR7nir21--
