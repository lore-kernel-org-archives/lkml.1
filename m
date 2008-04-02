Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYDBAYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYDBAYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 20:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbYDBAYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 20:24:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33714 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbYDBAYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 20:24:06 -0400
Date: Wed, 2 Apr 2008 11:23:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc8
Message-Id: <20080402112355.c86d9eda.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.1.00.0804011257310.14670@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0804011257310.14670@woody.linux-foundation.org>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__2_Apr_2008_11_23_55_+1100_TRBWAf2MEA638csD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Apr_2008_11_23_55_+1100_TRBWAf2MEA638csD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 1 Apr 2008 13:08:57 -0700 (PDT) Linus Torvalds <torvalds@linux-foun=
dation.org> wrote:
>
> A lot of the one-liners are some sparse cleanups, which is probably=20
> unnecessary noise at this point, but when Al sends me a series I just ten=
d=20
> to apply it because his patches tend to be rather careful and basically=20
> always correct.

The downside is that at least some of these were already pending in
maintainers trees for 2.6.26 (among other changes) and so have now caused
(unnecessary) merge conflicts.  Is there some reason that these fixes
can't go through the subsystem trees (especially once we get past rc1 (or
2) and people are gearing up for the next merge window)?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__2_Apr_2008_11_23_55_+1100_TRBWAf2MEA638csD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH8tIhTgG2atn1QN8RAhgsAJ0eWw+leh94vxStO+XNMxKP77GbiACglHnZ
xp8SBjF9NlU4SV0exyyiwng=
=dHM9
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Apr_2008_11_23_55_+1100_TRBWAf2MEA638csD--
