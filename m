Return-Path: <linux-kernel-owner+w=401wt.eu-S1763971AbYBNXxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763971AbYBNXxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756640AbYBNXwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:52:50 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37701 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756167AbYBNXwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:52:49 -0500
Date: Fri, 15 Feb 2008 10:52:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: first tree
Message-Id: <20080215105244.f225a295.sfr@canb.auug.org.au>
In-Reply-To: <20080214205031.GD21894@uranus.ravnborg.org>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
	<20080214202032.GB16545@kroah.com>
	<20080214205031.GD21894@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__15_Feb_2008_10_52_44_+1100_iz6EgYVKJzada2S2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Feb_2008_10_52_44_+1100_iz6EgYVKJzada2S2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

On Thu, 14 Feb 2008 21:50:31 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:
>
> A non-intrusive way to do so would be to add a file in the
> top-level directory and name it localversion*.
>=20
> For example:
> echo '-next' > localversion-next

Excellent, I will do this for the next release.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__15_Feb_2008_10_52_44_+1100_iz6EgYVKJzada2S2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtNRRTgG2atn1QN8RAq3JAJ9QihXlYLmW+tQmAo8vrhftFCi0twCePqXE
eiq5f4ETvqX0OYNXll7s/9Q=
=Xa5R
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Feb_2008_10_52_44_+1100_iz6EgYVKJzada2S2--
