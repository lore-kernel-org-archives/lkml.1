Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288Ab0ADFpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab0ADFpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 00:45:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153Ab0ADFo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 00:44:59 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56736 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab0ADFo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 00:44:58 -0500
Date: Mon, 4 Jan 2010 16:44:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: kgdb tree build failure
Message-Id: <20100104164452.2803d62e.sfr@canb.auug.org.au>
In-Reply-To: <20100104164209.a5ac8d6a.sfr@canb.auug.org.au>
References: <20100104164209.a5ac8d6a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__4_Jan_2010_16_44_52_+1100_eFcDGDEjB=U0RumH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Jan_2010_16_44_52_+1100_eFcDGDEjB=U0RumH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On Mon, 4 Jan 2010 16:42:09 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next build (arm realview_defconfig) failed like this:
                                ^^^^^^^^^
Most of the other arm builds failed the same way ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__4_Jan_2010_16_44_52_+1100_eFcDGDEjB=U0RumH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktBgFQACgkQjjKRsyhoI8xceACfcgW3lh76+ewR09KzbG1NWhvl
HJQAnRq/irFJhU6mViv6eL6v4qchfODW
=wRgs
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Jan_2010_16_44_52_+1100_eFcDGDEjB=U0RumH--
