Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988Ab0ATXTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab0ATXTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082Ab0ATXTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:19:36 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39261 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974Ab0ATXTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:19:36 -0500
Date: Thu, 21 Jan 2010 10:19:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: limits tree fetch error
Message-Id: <20100121101928.014ae274.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_Jan_2010_10_19_28_+1100_DzJqq+zptXBlTPYL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Jan_2010_10_19_28_+1100_DzJqq+zptXBlTPYL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next fetch of the limits tree produced this error:

decibel.fi.muni.cz[0: 147.251.50.163]: errno=3DConnection timed out
fatal: unable to connect a socket (Connection timed out)

Just letting you know.  I will use the tree from yesterday.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__21_Jan_2010_10_19_28_+1100_DzJqq+zptXBlTPYL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktXj4AACgkQjjKRsyhoI8wlAgCgiwGZp2TO87yl6oV7tFYtNFmC
BNoAoI81StsfYLvhlC8NjWtCP9I5OmaR
=PRjV
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Jan_2010_10_19_28_+1100_DzJqq+zptXBlTPYL--
