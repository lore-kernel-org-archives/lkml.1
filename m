Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbZF3BRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbZF3BRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 21:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759012AbZF3BRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 21:17:08 -0400
Received: from tamriel.snowman.net ([72.66.115.51]:59938 "EHLO
	tamriel.snowman.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbZF3BRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 21:17:07 -0400
Date: Mon, 29 Jun 2009 21:17:09 -0400
From: Stephen Frost <sfrost@snowman.net>
To: dann frazier <dannf@hp.com>
Cc: Alex Chiang <achiang@hp.com>, linux-kernel@vger.kernel.org,
       David Altobelli <david.altobelli@hp.com>, nagananda.chumbalkar@hp.com
Subject: Re: ACPI issues on HP DL585 G2
Message-ID: <20090630011709.GT20436@tamriel.snowman.net>
References: <20090628034038.GK20436@tamriel.snowman.net> <20090628172052.GA13957@ldl.fc.hp.com> <20090628223258.GP20436@tamriel.snowman.net> <20090630011541.GL22480@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1MV0VfA6Y2yiVCnw"
Content-Disposition: inline
In-Reply-To: <20090630011541.GL22480@ldl.fc.hp.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snowman.net
X-Operating-System: Linux/2.6.26-1-amd64 (x86_64)
X-Uptime: 21:16:40 up 18 days, 22:43, 24 users,  load average: 0.06, 0.06,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1MV0VfA6Y2yiVCnw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* dann frazier (dannf@hp.com) wrote:
> On Sun, Jun 28, 2009 at 06:32:58PM -0400, Stephen Frost wrote:
> > * Alex Chiang (achiang@hp.com) wrote:
> > > I'm just scanning mail on the weekend, but what version of the
> > > BIOS are you on? Do you have the latest?
> >=20
> > Check the message I just posted, it includes a dmesg under 2.6.30 (also
> > with noapic, since it didn't boot w/o it again).
>=20
> fyi, I tested an HP DL585 G2 w/ the same 2.6.30 kernel build
> and didn't have any problems. I am running the A07 3/11/2009 BIOS.
> dmesg output follows:

Yeah, it's working fine on some of my other DL585's too. :/  I've really
got no idea what's up with this box.  Thanks for the info tho.

	Stephen

--1MV0VfA6Y2yiVCnw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpJZ5UACgkQrzgMPqB3kijsrACdHEsrIFk7dYnzCcdHXFAfXov0
WmsAnjSWknjywW6E70MYVs4AaxlOco6y
=24gE
-----END PGP SIGNATURE-----

--1MV0VfA6Y2yiVCnw--
