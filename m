Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbYDZNyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbYDZNyz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 09:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYDZNys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 09:54:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36657 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbYDZNyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 09:54:47 -0400
Date: Sat, 26 Apr 2008 23:54:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Announce: Semaphore-Removal tree
Message-Id: <20080426235439.52031d35.sfr@canb.auug.org.au>
In-Reply-To: <20080425170021.GH14990@parisc-linux.org>
References: <20080425170021.GH14990@parisc-linux.org>
X-Mailer: Sylpheed 2.5.0beta2 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__26_Apr_2008_23_54_39_+1000_r8N4ML6egkr=vNME"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__26_Apr_2008_23_54_39_+1000_r8N4ML6egkr=vNME
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Willy,

On Fri, 25 Apr 2008 11:00:21 -0600 Matthew Wilcox <matthew@wil.cx> wrote:
>
> Stephen, could you pick these patches up for linux-next?
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git semaphore-re=
moval

This is in addition to the semaphore branch? Should it go before or after
that i.e. does it depend on it?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__26_Apr_2008_23_54_39_+1000_r8N4ML6egkr=vNME
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIEzQkTgG2atn1QN8RAv0xAJ9zJn9RF6VTpaufW9/cJE8zjOICCACbBvIN
u0pgNxz/Tj+Io86W2rVBrXA=
=5xeL
-----END PGP SIGNATURE-----

--Signature=_Sat__26_Apr_2008_23_54_39_+1000_r8N4ML6egkr=vNME--
