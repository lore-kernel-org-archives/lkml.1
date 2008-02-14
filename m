Return-Path: <linux-kernel-owner+w=401wt.eu-S1762810AbYBNXcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762810AbYBNXcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758152AbYBNXb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:31:56 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46080 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877AbYBNXbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:31:55 -0500
Date: Fri, 15 Feb 2008 10:31:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: first tree
Message-Id: <20080215103150.3aa9ed4e.sfr@canb.auug.org.au>
In-Reply-To: <20080214202032.GB16545@kroah.com>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
	<20080214202032.GB16545@kroah.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__15_Feb_2008_10_31_50_+1100_.omtC7d64ksqIugz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Feb_2008_10_31_50_+1100_.omtC7d64ksqIugz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 14 Feb 2008 12:20:32 -0800 Greg KH <greg@kroah.com> wrote:
>
> Could you change the Makefile to show that if we build and run this
> tree, it really isn't Linus's tree?  Yes, I know the -git number will be
> different, but that might not be very obvious to people reading bug
> reports on lkml.
>=20
> Just adding "-next" to the extraversion would be great.

Yes, sure, I should have though of that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__15_Feb_2008_10_31_50_+1100_.omtC7d64ksqIugz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtM9qTgG2atn1QN8RAiD4AJ4ptrX6J+OLsEO3vWXBG3qTzZDx3ACgg5tL
2Mi+cUfigBTf76uWYX1UJkk=
=7V6M
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Feb_2008_10_31_50_+1100_.omtC7d64ksqIugz--
