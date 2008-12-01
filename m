Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbYLAWKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbYLAWKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 17:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbYLAWJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 17:09:57 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:25037 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbYLAWJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 17:09:53 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-nfs@vger.kernel.org, Max Kellermann <mk@cm4all.com>,
       linux-kernel@vger.kernel.org, gcosta@redhat.com,
       Grant Coady <grant_lkml@dodo.com.au>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
In-Reply-To: <1228090631.7112.11.camel@heimdal.trondhjem.org>
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
	 <1224484046.23068.14.camel@localhost.localdomain>
	 <1225539927.2221.3.camel@localhost.localdomain>
	 <1225546878.4390.3.camel@heimdal.trondhjem.org>
	 <1227596962.16868.22.camel@localhost.localdomain>
	 <1227619696.7057.19.camel@heimdal.trondhjem.org>
	 <1227620339.9425.99.camel@zakaz.uk.xensource.com>
	 <1227621434.7057.33.camel@heimdal.trondhjem.org>
	 <1227621877.9425.102.camel@zakaz.uk.xensource.com>
	 <1227737539.31008.2.camel@localhost.localdomain>
	 <1228090631.7112.11.camel@heimdal.trondhjem.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fdxN1Lu/rB3vInNey/+0"
Date: Mon, 01 Dec 2008 22:09:43 +0000
Message-Id: <1228169383.20370.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 0/3] NFS regression in 2.6.26?, "task blocked for more
	than 120 seconds"
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=jSbuyrlv4UgA:10 a=ehd10kmKHQgA:10 a=uCVLkDA93K9barMAmS8A:9 a=Glxot8Hg9Hb3eAKT35DnhPKdzEAA:4 a=LY0hPdMaydYA:10 a=kmLn9c7qrdhHQqvkNk0A:9 a=Y6evkrOyf-VdcygsvDZu5PM3G24A:4 a=rPt6xJ-oxjAA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fdxN1Lu/rB3vInNey/+0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-11-30 at 19:17 -0500, Trond Myklebust wrote:=20
> Can you see if the following 3 patches help? They're against 2.6.28-rc6,
> but afaics the problems are pretty much the same on 2.6.26.

Thanks.

The server was actually running 2.6.25.7 but the matching sources have
since been removed the backports.org so I've reproduce with 2.6.26 and
now I'll add the patches.

Ian.

--=20
Ian Campbell

It has been said that man is a rational animal.  All my life I have
been searching for evidence which could support this.
		-- Bertrand Russell

--=-fdxN1Lu/rB3vInNey/+0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk0YKQACgkQM0+0qS9rzVnbfgCeI9t5hcCZr1uJOdXqiL9JTIlF
bLQAniodHB39FqnSdZvWbEMJPh0Sxp1i
=dJAs
-----END PGP SIGNATURE-----

--=-fdxN1Lu/rB3vInNey/+0--

