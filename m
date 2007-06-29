Return-Path: <linux-kernel-owner+w=401wt.eu-S933802AbXF2Qh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933802AbXF2Qh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 12:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932078AbXF2Qhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 12:37:50 -0400
Received: from mtl.rackplans.net ([69.90.0.18]:34985 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760139AbXF2Qht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 12:37:49 -0400
Date: Fri, 29 Jun 2007 12:37:47 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: =?iso-8859-15?q?Zolt=E1n_HUBERT?= <zoltan.hubert@zzaero.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Please release a stable kernel Linux 3.0
In-Reply-To: <200706271118.36985.zoltan.hubert@zzaero.com>
Message-ID: <Pine.LNX.4.64.0706291227040.1395@mtl.rackplans.net>
References: <200706212349.54983.zoltan.hubert@zzaero.com>
 <200706261637.22820.zoltan.hubert@zzaero.com>
 <6FD45914-1793-45D5-B0A1-F5D32ED38017@e18.physik.tu-muenchen.de>
 <200706271118.36985.zoltan.hubert@zzaero.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="658624935-1208726249-1183135067=:1395"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--658624935-1208726249-1183135067=:1395
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 27 Jun 2007, Zolt=E1n HUBERT wrote:

> I don't remember how it was during 2.4 and before, but I=20
> find it very suspicious that SuSE and RedHat only provide=20
> 2.6.10 and 2.6.9 for their OS. It looks as if THEY didn't=20
> trust 2.6.x to be a replacement to 2.6.y
>=20
> And as I understand it, this is (was ?) the whole point of=20
> stable/development kernels. "We" can trust a newer stable=20
> kernel to be a drop-in replacement for an older stable=20
> kernel (from the same series), while development kernels=20
> need time to stabilize with the new whizz-bang-pfouit stuff=20
> that you all so nicely add.=20
>=20
> Are the good ol' days lost in nostalgia ?

Lost? maybe.  Improved on, defiantly so it's loss isn't a bad thing.

The 2.4/2.5 split was, as far as I recall, a mess.  2.5 had too many=20
changes to stabilize in any reasonable amount of time and 2.4 then needed=
=20
new drivers and features to keep it from becoming obsolete.  Back porting=
=20
drivers without the needed infrastructure resulted in instabilities in=20
the 2.4 branch.

I recall one time where I needed a certain raid device working and not a=20
single kernel had that driver working properly.  2.4.x oopsed in the=20
driver after random intervals and the 2.5 kernel crashed in other places.

Now development is broken into smaller stages that are easier to debug and=
=20
made stable in shorter time.  If I just need to update a kernel and don't=
=20
need any new features and drivers I can just update to the next point=20
release and I know it won't break anything.  If I want new features I can=
=20
update to the latest stable branch or the latest pre release but either=20
way my stuff is more likely to work than I did back in the 2.5 days.

I think people who keep demanding a return to the old development system=20
forget how badly it sucked in the first place.

=09Gerhard



--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
--658624935-1208726249-1183135067=:1395--
