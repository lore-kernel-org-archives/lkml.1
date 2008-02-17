Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbYBQX1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbYBQX1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 18:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbYBQX12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 18:27:28 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33756 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420AbYBQX11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 18:27:27 -0500
Date: Mon, 18 Feb 2008 10:27:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: first tree
Message-Id: <20080218102722.7c4bc8ce.sfr@canb.auug.org.au>
In-Reply-To: <20080217190957.GA29415@jupiter.solarsys.private>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
	<20080217190957.GA29415@jupiter.solarsys.private>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Feb_2008_10_27_22_+1100_TDOZ8rzXP7aWcfTj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Feb_2008_10_27_22_+1100_TDOZ8rzXP7aWcfTj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Sun, 17 Feb 2008 14:09:57 -0500 "Mark M. Hoffman" <mhoffman@lightlink.co=
m> wrote:
>
> You can add the hwmon testing tree (from MAINTAINERS):=20
>=20
> > git lm-sensors.org:/kernel/mhoffman/hwmon-2.6.git testing
>=20
> This tree gets rebased pretty much whenever Linus adds a new tag.  As a
> rule of thumb, you should merge from Jean Delvare's i2c tree first.  The
> hwmon/testing tree does not usually depend on anything else.

Added, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Feb_2008_10_27_22_+1100_TDOZ8rzXP7aWcfTj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHuMLeTgG2atn1QN8RAlU2AJ912oBo7U9Q2mAUea0/VQvdemOtsQCghPh0
e4ii09OmkfijEaJrd6nn/qI=
=0wLN
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Feb_2008_10_27_22_+1100_TDOZ8rzXP7aWcfTj--
