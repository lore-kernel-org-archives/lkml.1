Return-Path: <linux-kernel-owner+w=401wt.eu-S1161130AbXAZSQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161130AbXAZSQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161124AbXAZSQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:16:34 -0500
Received: from mail.gmx.net ([213.165.64.20]:59136 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1161130AbXAZSQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:16:33 -0500
X-Authenticated: #815327
From: Malte =?utf-8?q?Schr=C3=B6der?= <MalteSch@gmx.de>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.20-rc6: known unfixed regressions (part 2)
Date: Fri, 26 Jan 2007 19:16:25 +0100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Vladimir V. Saveliev" <vs@namesys.com>, reiserfs-dev@namesys.com
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org> <20070126181132.GN17836@stusta.de>
In-Reply-To: <20070126181132.GN17836@stusta.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart26594173.iYjugDN5fy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200701261916.29805.MalteSch@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart26594173.iYjugDN5fy
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 26 January 2007 19:11, Adrian Bunk wrote:
> Subject    : BUG: at mm/truncate.c:60 cancel_dirty_page()  (reiserfs)
> References : http://lkml.org/lkml/2007/1/7/117
>              http://lkml.org/lkml/2007/1/10/202
> Submitter  : Malte Schr=C3=B6der <MalteSch@gmx.de>
> Handled-By : Vladimir V. Saveliev <vs@namesys.com>
>              Nick Piggin <nickpiggin@yahoo.com.au>
> Patch      : http://lkml.org/lkml/2007/1/10/202
> Status     : problem is being discussed

This did not happen again.


=2D-=20
=2D--------------------------------------
Malte Schr=C3=B6der
MalteSch@gmx.de
ICQ# 68121508
=2D--------------------------------------


--nextPart26594173.iYjugDN5fy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBFukV94q3E2oMjYtURAlKjAJ9VzaMznF7SNqB/D71XbJnKG4gXJACgwazz
PKWVY8s71bRNNjAIW2Ci3ps=
=ryug
-----END PGP SIGNATURE-----

--nextPart26594173.iYjugDN5fy--
