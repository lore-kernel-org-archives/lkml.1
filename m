Return-Path: <linux-kernel-owner+w=401wt.eu-S965275AbXCTKQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965275AbXCTKQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 06:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965310AbXCTKQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 06:16:39 -0400
Received: from smtp13.wxs.nl ([195.121.247.4]:40994 "EHLO smtp13.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965275AbXCTKQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 06:16:35 -0400
Date: Tue, 20 Mar 2007 11:19:52 +0100
From: jos poortvliet <jos@mijnkamer.nl>
X-Face: $0>4o"Xx2u2q(Tx!D+6~yPc{ZhEfnQnu:/nthh%Kr%f$aiATk$xjx^X4admsd*)=?utf-8?q?IZz=3A=5FkT=0A=09=7CurITP!=2E?=)L`*)Vw@4\@6>#r;3xSPW`,~C9vb`W/s]}Gq]b!o_/+(lJ:b)=?utf-8?q?T0=26KCLMGvG=7CS=5E=0A=09z=7B=5C=2E7EtehxhFQE=27eYSsir/=7CtQ?=
 =?utf-8?q?j=23rWQe4o?=>WC>_R<vO,d]czmqWYkq[v~iB.e_GuxB'")
 =?utf-8?q?p3=0A=09jGdrhlY4=5E!vd=3F=3AegW?=)xn&fP4!FV<.
Subject: Re: [ck] Re: RSDL v0.31
In-reply-to: <45FEF6D1.7020309@tmr.com>
To: ck@vds.kolivas.org
Cc: Bill Davidsen <davidsen@tmr.com>, Kasper Sandberg <lkml@metanurb.dk>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicholas Miell <nmiell@comcast.net>
Message-id: <200703201119.53258.jos@mijnkamer.nl>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart2014544.tmM9QgLjsS
Content-transfer-encoding: 7bit
User-Agent: KMail/1.9.6
References: <200703042335.26785.a1426z@gawab.com>
 <1174211853.10498.25.camel@localhost> <45FEF6D1.7020309@tmr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2014544.tmM9QgLjsS
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Op Tuesday 20 March 2007, schreef Bill Davidsen:
> Kasper Sandberg wrote:
> > On Sun, 2007-03-18 at 08:38 +0100, Mike Galbraith wrote:
> >> On Sun, 2007-03-18 at 08:22 +0100, Radoslaw Szkodzinski wrote:
> >>> I'd recon KDE regresses because of kioslaves waiting on a pipe
> >>> (communication with the app they're doing IO for) and then expiring.
> >>> That's why splitting IO from an app isn't exactly smart. It should at
> >>> least be ran in an another thread.
> >>
> >> Hm.  Sounds rather a lot like the...
> >> X sucks, fix X and RSDL will rock your world.  RSDL is perfect.
> >> ...that I've been getting.
> >
> > not really, only X sucks. KDE works atleast as good with rsdl as
> > vanilla. i dont know how originally said kde works worse, wasnt it just
> > someone that thought?
>
> It was probably me, and I had the opinion that KDE is not as smooth as
> GNOME with RSDL. I haven't had time to measure, but using for daily
> stuff for about an hour each way hasn't changed my opinion. Every once
> in a while KDE will KLUNK to a halt for 200-300ms doing mundane stuff
> like redrawing a page, scrolling, etc. I don't see it with GNOME.

yeah, here too... sometimes even longer (and I have a dualcore, 3gb ram,=20
damnit!)

=2D-=20
Disclaimer:

Alles wat ik doe denk en zeg is gebaseerd op het wereldbeeld wat ik nu heb.=
=20
Ik ben niet verantwoordelijk voor wijzigingen van de wereld, of het beeld w=
at=20
ik daarvan heb, noch voor de daaruit voortvloeiende gedragingen van mezelf.=
=20
Alles wat ik zeg is aardig bedoeld, tenzij expliciet vermeld.

Please avoid sending me Word or PowerPoint attachments.
See http://www.gnu.org/philosophy/no-word-attachments.html

--nextPart2014544.tmM9QgLjsS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBF/7VJ+wgQ1AD35iwRAtbLAKCSB/KBHbBZxTQQZYkz/bI8xNjkAQCgn7S8
m7EaP+1wDi0caumkmCS5W1I=
=LfjW
-----END PGP SIGNATURE-----

--nextPart2014544.tmM9QgLjsS--
