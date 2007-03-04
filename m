Return-Path: <linux-kernel-owner+w=401wt.eu-S932987AbXCDQG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987AbXCDQG0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 11:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932991AbXCDQG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 11:06:26 -0500
Received: from psmtp03.wxs.nl ([195.121.247.12]:55818 "EHLO psmtp03.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932987AbXCDQGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 11:06:25 -0500
Date: Sun, 04 Mar 2007 17:08:50 +0100
From: jos poortvliet <jos@mijnkamer.nl>
X-Face: $0>4o"Xx2u2q(Tx!D+6~yPc{ZhEfnQnu:/nthh%Kr%f$aiATk$xjx^X4admsd*)=?utf-8?q?IZz=3A=5FkT=0A=09=7CurITP!=2E?=)L`*)Vw@4\@6>#r;3xSPW`,~C9vb`W/s]}Gq]b!o_/+(lJ:b)=?utf-8?q?T0=26KCLMGvG=7CS=5E=0A=09z=7B=5C=2E7EtehxhFQE=27eYSsir/=7CtQ?=
 =?utf-8?q?j=23rWQe4o?=>WC>_R<vO,d]czmqWYkq[v~iB.e_GuxB'")
 =?utf-8?q?p3=0A=09jGdrhlY4=5E!vd=3F=3AegW?=)xn&fP4!FV<.
Subject: Re: [ck] Re: [ANNOUNCE] RSDL completely fair starvation free
 interactive cpu scheduler
In-reply-to: <20070304143638.GG943@1wt.eu>
To: ck@vds.kolivas.org
Cc: Willy Tarreau <w@1wt.eu>, Con Kolivas <kernel@kolivas.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
Message-id: <200703041708.54953.jos@mijnkamer.nl>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart1874165.XqAVauXNLj
Content-transfer-encoding: 7bit
User-Agent: KMail/1.9.5 + Features
References: <200703041800.53360.kernel@kolivas.org>
 <200703050049.50149.kernel@kolivas.org> <20070304143638.GG943@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1874165.XqAVauXNLj
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Op Sunday 04 March 2007, schreef Willy Tarreau:
> Hi Con !
> > This was designed to be robust for any application since linux demands a
> > general purpose scheduler design, while preserving interactivity, inste=
ad
> > of optimising for one particular end use.
>
> Well, I haven't tested it yet, but your design choices please me. As you
> know, I've been one of those encountering big starvation problems with
> the original scheduler, making 2.6 unusable for me in many situations. I
> welcome your work and want to thank you for the time you spend trying to
> fix it.
>
> Keep up the good work,
> Willy
>
> PS: I've looked at your graphs, I hope you're on the way to something
> really better than the 21 first 2.6 releases !
Well, imho his current staircase scheduler already does a better job compar=
ed=20
to mainline, but it won't make it in (or at least, it's not likely). So we=
=20
can hope this WILL make it into mainline, but I wouldn't count on it.

grtz

Jos



=2D-=20
Disclaimer:

Alles wat ik doe denk en zeg is gebaseerd op het wereldbeeld wat ik nu heb.=
=20
Ik ben niet verantwoordelijk voor wijzigingen van de wereld, of het beeld w=
at=20
ik daarvan heb, noch voor de daaruit voortvloeiende gedragingen van mezelf.=
=20
Alles wat ik zeg is aardig bedoeld, tenzij expliciet vermeld.

--nextPart1874165.XqAVauXNLj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBF6u8W+wgQ1AD35iwRAkbxAKDXjaYWEXkVO7b6pMXD78YvOYiBcgCgiBaG
k6xhN4SArbGWqbht3dvsKQo=
=IPOr
-----END PGP SIGNATURE-----

--nextPart1874165.XqAVauXNLj--
