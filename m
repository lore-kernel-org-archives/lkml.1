Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbYCNRoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbYCNRoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 13:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbYCNRog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 13:44:36 -0400
Received: from orchitis.omgwallhack.org ([66.179.21.205]:42072 "EHLO
	smtp.omgwallhack.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbYCNRog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 13:44:36 -0400
Subject: Re: Hang on suspend
From: Julian Blake Kongslie <jblake@omgwallhack.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080313081319.GD19808@elf.ucw.cz>
References: <1203553943.4422.25.camel@dukephillips.omgwallhack.org>
	 <200802241223.46930.rjw@sisk.pl>
	 <1203887415.4154.4.camel@dukephillips.omgwallhack.org>
	 <200802242335.01800.rjw@sisk.pl>
	 <1203893049.3983.6.camel@dukephillips.omgwallhack.org>
	 <20080313081319.GD19808@elf.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9JdrZKbDWw/LDEw6dzjx"
Organization: Fists of Righteous Harmony
Date: Fri, 14 Mar 2008 10:43:49 -0700
Message-Id: <1205516629.3939.2.camel@dukephillips.omgwallhack.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9JdrZKbDWw/LDEw6dzjx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-03-13 at 09:13 +0100, Pavel Machek wrote:
> Any news on this? Did bisect show something interesting?

I'm afraid not; I think this may be hardware-related on my end, because
it seems to vary with the size of the kernel image, of all things.

--=20
-Julian Blake Kongslie
<jblake@omgwallhack.org>

If this is a mailing list, please CC me on replies.
vim: set ft=3Dtext :

--=-9JdrZKbDWw/LDEw6dzjx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Don't have my public key? Email <jblake@omgwallhack.org> and I'll gladly mail it to you.

iD8DBQBH2rlVuU009xtCYDURAn8uAJ9qFD2W4sIEAJMGhhYfyckFFQpKSACeMgqv
sGnUbbxg3Kr4Lzl3mzln8KM=
=iNvs
-----END PGP SIGNATURE-----

--=-9JdrZKbDWw/LDEw6dzjx--

