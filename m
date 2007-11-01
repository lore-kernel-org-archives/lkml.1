Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbXKAAvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbXKAAvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 20:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbXKAAvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 20:51:03 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48730 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbXKAAvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 20:51:01 -0400
Date: Thu, 1 Nov 2007 11:50:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hiddev: compat_ptr() returns a void *
Message-Id: <20071101115056.fdf8a95c.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0710311217370.18815@twin.jikos.cz>
References: <20071031145153.30f9d3dd.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0710311217370.18815@twin.jikos.cz>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__1_Nov_2007_11_50_56_+1100_u5I=IRqrvhpb0kMh"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Nov_2007_11_50_56_+1100_u5I=IRqrvhpb0kMh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 31 Oct 2007 12:27:24 +0100 (CET) Jiri Kosina <jikos@jikos.cz> wrote:
>
> I already have this fixed in my tree, sorry.

As long as it gets fixed, I don't mind.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__1_Nov_2007_11_50_56_+1100_u5I=IRqrvhpb0kMh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHKSL1TgG2atn1QN8RAujQAJ9rrz6BRc95JDFoQ2KOr5B2VYMqFQCfR/Ec
ImFvpM0ogVEHeDdCOV4dQfQ=
=xMui
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Nov_2007_11_50_56_+1100_u5I=IRqrvhpb0kMh--
