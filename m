Return-Path: <linux-kernel-owner+w=401wt.eu-S1946468AbXBIN7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946468AbXBIN7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 08:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946470AbXBIN7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 08:59:37 -0500
Received: from smtp16.wxs.nl ([195.121.247.7]:64110 "EHLO smtp16.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946468AbXBIN7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 08:59:36 -0500
Date: Fri, 09 Feb 2007 15:00:59 +0100
From: jos poortvliet <jos@mijnkamer.nl>
X-Face: $0>4o"Xx2u2q(Tx!D+6~yPc{ZhEfnQnu:/nthh%Kr%f$aiATk$xjx^X4admsd*)=?utf-8?q?IZz=3A=5FkT=0A=09=7CurITP!=2E?=)L`*)Vw@4\@6>#r;3xSPW`,~C9vb`W/s]}Gq]b!o_/+(lJ:b)=?utf-8?q?T0=26KCLMGvG=7CS=5E=0A=09z=7B=5C=2E7EtehxhFQE=27eYSsir/=7CtQ?=
 =?utf-8?q?j=23rWQe4o?=>WC>_R<vO,d]czmqWYkq[v~iB.e_GuxB'")
 =?utf-8?q?p3=0A=09jGdrhlY4=5E!vd=3F=3AegW?=)xn&fP4!FV<.
Subject: Re: [ck] Re: Swap prefetch merge plans
In-reply-to: <200702100022.45464.kernel@kolivas.org>
To: Con Kolivas <kernel@kolivas.org>
Cc: ck@vds.kolivas.org, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Message-id: <200702091501.04265.jos@mijnkamer.nl>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart1201329.gBYkiMHHnp
Content-transfer-encoding: 7bit
User-Agent: KMail/1.9.5 + Features
References: <200702091038.37143.kernel@kolivas.org>
 <200702091413.06949.jos@mijnkamer.nl> <200702100022.45464.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1201329.gBYkiMHHnp
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Op Friday 09 February 2007, schreef Con Kolivas:
> On Saturday 10 February 2007 00:13, jos poortvliet wrote:
> > Nobody has said anything about costs, indeed. Now afaik, swap prefetch =
is
> > designed to have no/as little as possible costs, so that makes sense.
> > Does it have to have some bugs, which have to be adressed, before it can
> > enter? I'm sure this can be arranged, right, Con?
> >
> > Sorry if I sound sarcastic. I'm no hacker myself, and sometimes these
> > discussions don't make sense to me. A bit like the Staircase thingy ->
> >
> > "hi, I've got this piece of code which does the same as that piece, but
> > better"
> > "Why didn't you improve the old code?"
> > "This is a better design -> half the code but doing a better job"
> > "Well, it's not tested as much, so it won't go in. Go away!"
> >
> > There where those comments from Torvalds some time ago in an interview,
> > about the kernel community becoming harder to get involved with. As an
> > outsider, it sure seems so. I read frustrations everywhere. What about
> > the kevent guy, his blog: http://tservice.net.ru/~s0mbre/blog
> >
> > I stumbled upon it when reading LWN. Seems pretty sad... I don't get the
> > technical stuff, but the frustration almost blows up your monitor. Is
> > there something fundamentally wrong with the kernel-hackers-culture, or
> > are these incidents?
>
> I greatly appreciate the support. Truly I do.
>
> But I do not like the direction this argument is going. Please let it go.

Ok. I appologize to those who might have felt attacked, this wasn't meant=20
personally to anybody, more to the community as a whole.

--nextPart1201329.gBYkiMHHnp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBFzH6g+wgQ1AD35iwRAkosAJ4s/nEXStSv7Z1PwNCE0jnt8c0txwCeMod2
J7iSmANaorOq28NUiDIciyo=
=VG2e
-----END PGP SIGNATURE-----

--nextPart1201329.gBYkiMHHnp--
