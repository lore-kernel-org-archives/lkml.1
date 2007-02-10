Return-Path: <linux-kernel-owner+w=401wt.eu-S932736AbXBJQLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbXBJQLI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 11:11:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932740AbXBJQLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 11:11:08 -0500
Received: from smtp16.wxs.nl ([195.121.247.7]:50643 "EHLO smtp16.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932736AbXBJQLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 11:11:05 -0500
Date: Sat, 10 Feb 2007 17:12:51 +0100
From: jos poortvliet <jos@mijnkamer.nl>
X-Face: $0>4o"Xx2u2q(Tx!D+6~yPc{ZhEfnQnu:/nthh%Kr%f$aiATk$xjx^X4admsd*)=?utf-8?q?IZz=3A=5FkT=0A=09=7CurITP!=2E?=)L`*)Vw@4\@6>#r;3xSPW`,~C9vb`W/s]}Gq]b!o_/+(lJ:b)=?utf-8?q?T0=26KCLMGvG=7CS=5E=0A=09z=7B=5C=2E7EtehxhFQE=27eYSsir/=7CtQ?=
 =?utf-8?q?j=23rWQe4o?=>WC>_R<vO,d]czmqWYkq[v~iB.e_GuxB'")
 =?utf-8?q?p3=0A=09jGdrhlY4=5E!vd=3F=3AegW?=)xn&fP4!FV<.
Subject: Re: [ck] Re: Swap prefetch merge plans
In-reply-to: <20070209155410.59e0cf4b.randy.dunlap@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck@vds.kolivas.org,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Message-id: <200702101712.55855.jos@mijnkamer.nl>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart1767567.0p22RZl49c
Content-transfer-encoding: 7bit
User-Agent: KMail/1.9.5 + Features
References: <200702091038.37143.kernel@kolivas.org>
 <45CD0557.4090709@redhat.com> <20070209155410.59e0cf4b.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1767567.0p22RZl49c
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Op Saturday 10 February 2007, schreef Randy Dunlap:
> On Fri, 09 Feb 2007 18:35:51 -0500 Chuck Ebbert wrote:
> > Andrew Morton wrote:
> > > I have an email sitting in my drafts folder stating that I'll no long=
er
> > > accept any features unless they've been publically reviewed in detail
> > > and run-time tested by a third party.  The idea being to force people
> > > to spend more time reviewing and testing each other's stuff and less
> > > time writing new stuff.  Maybe on a sufficiently gloomy day I'll
> > > actually send it.
> >
> > /me sneaks into Andrew's office and sends it out.
>
> Thanks.  8)

Well, is it smart? I mean, it's not stupid of course, but it has its=20
disadvantages which Andrew already mentioned. Less time for writing new=20
stuff. So it is a tradeoff, most likely the reason why he didn't send it ye=
t.=20

What are the sideeffects of this? Does it repel people? Or controversely, d=
oes=20
it bring new people in, who are asked by others to do a little review?=20

Does it lead to better documented and commented code, to help the review=20
process? Does it lead to worse reviews? Does it stiffle innovation, or, as=
=20
more ppl work on one patch, does it stimulate it? Will people start to=20
cooperate more, or will they argue and fight when someone refuses to review=
=20
patches?

Anyway, you can't know these in advance, and watching what it does is the o=
nly=20
way to find out. Its Andrew's call, either way.

Days should't be gloomy, but if they do, trying new things is the only way =
to=20
find a solution. The growing amount of people workin on the kernel and the=
=20
increasing demands from the users force the kernel community to evolve, and=
=20
central figures like Andrew and Linus play a big role in this. I think you=
=20
guys have done a great job until now, and I trust you can keep it that way.

Jos

--nextPart1767567.0p22RZl49c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBFze8H+wgQ1AD35iwRAg5UAJoD7FOSsSY7McfU+TijKaRyAlSDCwCfeCfQ
8fgAQvegoyK+V0fPW1VmGVc=
=66jN
-----END PGP SIGNATURE-----

--nextPart1767567.0p22RZl49c--
