Return-Path: <linux-kernel-owner+w=401wt.eu-S933885AbYBNOeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885AbYBNOeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 09:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761427AbYBNOe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 09:34:28 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60405 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920AbYBNOe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 09:34:27 -0500
Date: Fri, 15 Feb 2008 01:34:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: first tree
Message-Id: <20080215013421.c081407d.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0802141503170.7699@twin.jikos.cz>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0802141503170.7699@twin.jikos.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__15_Feb_2008_01_34_21_+1100_WfUBrBs=p/IOzJ4z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Feb_2008_01_34_21_+1100_WfUBrBs=p/IOzJ4z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Feb 2008 15:06:28 +0100 (CET) Jiri Kosina <jikos@jikos.cz> wrote:
>
> On Fri, 15 Feb 2008, Stephen Rothwell wrote:
>=20
> > The tree consists of subsystem git and quilt trees.  Currently, the=20
> > quilt trees are integrated by importing them into appropriately based=20
> > git branches and then merging those branches. =20
>=20
> Now, would it be possible to have somewhere listed the URLs of git/quilt=
=20
> trees that were merged? The commit messages about merges with different=20
> branches aren't too informative, it might sometime be useful to know more=
=20
> about the trees that were merged.
>=20
> Maybe just an additional file somewhere in the root of the source tree=20
> would be sufficient ...

Good idea.  I have pushed out an extra commit that just contains the top
level "Trees" file.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__15_Feb_2008_01_34_21_+1100_WfUBrBs=p/IOzJ4z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtFFzTgG2atn1QN8RAmDVAJ9nGzGCB2hvJkYACIVpVsTC7HYcJgCeLp5d
awtC1vPf4N3L14wQO61/dNM=
=t58y
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Feb_2008_01_34_21_+1100_WfUBrBs=p/IOzJ4z--
