Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbZDNHXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbZDNHXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZDNHXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:23:24 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55481 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbZDNHXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:23:22 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Subject: Re: [RFC][patch] filesystem: Vmufat filesystem, version 4
Date: Tue, 14 Apr 2009 03:23:15 -0400
User-Agent: KMail/1.11.1 (Linux/2.6.28; KDE/4.2.1; x86_64; ; )
Cc: Paul Mundt <lethal@linux-sh.org>,
       "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-sh" <linux-sh@vger.kernel.org>,
       "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>,
       Sam Ravnborg <sam@ravnborg.org>
References: <1239654768.6542.10.camel@localhost.localdomain> <20090414070314.GB29075@linux-sh.org> <1239693375.6538.5.camel@localhost.localdomain>
In-Reply-To: <1239693375.6538.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart24798497.qPfQ16toom";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200904140323.19062.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart24798497.qPfQ16toom
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 14 April 2009 03:16:15 Adrian McMenamin wrote:
> On Tue, 2009-04-14 at 16:03 +0900, Paul Mundt wrote:
> > Everything about the on-disk format is tied to the VMU. Until that sinks
> > in, don't bother sending me email, thanks.
>
> No, everything in the file system is dependent on the specification. The
> specification is not dependent on the hardware. Those are the facts.

i must be slow because i tend to agree with Adrian here.  if the VMU is a=20
simple block device, then while the filesystem format may have been tailore=
d=20
to the exact hardware layout of the VMU, it doesnt mean that the resulting=
=20
filesystem spec will only work on that hardware.  then again, i didnt read =
the=20
entire source code from top to bottom ...
=2Dmike

--nextPart24798497.qPfQ16toom
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJJ5DnmAAoJEEFjO5/oN/WBtDYQAI3zGHtHtrY44jtSHUzn6no4
1EtSZvwJTcChf9dzguxlgsutfKg4QXHEcY7IHoFwx8LoGg84RiYpnsOMl1Wag5UG
v3jA2xz9YTj0Vr6m6HuEEscWECww/VxlT+5p8WKBuPyL3maSoZMPrYXs9mJgBl1b
HMc7X9KLMpOBs2lLzbJloYPWVO9O3SfrInzr7YnACVDvr/FKk6iGIFQ73dEhJrRN
NrtQs9Qqp6RqNoJx0lPZ3Ry0HyAI0pGFch/60nIw5ZX7/K86YZn4y2XdYZDGt19F
424XMdsoZ+8d5bQKOI50+aG/h5xr/Y9X2BzgxZJAOE5qJBzBvB/e0O1wLM3/1JrI
5B+0QSSvi7XC0CJYW81D9gsC9SyCpFDvRnPAV8pjbN+NcTcfDtmQi89XmmnSqZqN
Kfef5jbXBH6/oOo+cQr2eohsEL+6uXPUuA60ny32VtQvb4DMBHRPPFXZK5GoAo+E
CpuZi8BrL7WG2Wl295+2KXVg4AGyieFSXeAxFOofnBw/h9ctdsHc4OSwk1jyC7Jm
cWy24gd+I6tdWr73ghMxj96k2IAKvxYHvJvEwavEHUa99KKz7Ihf8setqlDMIsQj
CKI/m9hxQ5MwRVIdPr89MmgbIAZs4WRCx/2rzY7BbdKmjPtw5+RGiR0dcofvza06
rMll75elNXVGHV6+Lo9H
=Itxl
-----END PGP SIGNATURE-----

--nextPart24798497.qPfQ16toom--
