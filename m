Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919AbZF1WdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbZF1WdE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 18:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZF1Wcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 18:32:55 -0400
Received: from tamriel.snowman.net ([72.66.115.51]:44087 "EHLO
	tamriel.snowman.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZF1Wcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 18:32:55 -0400
Date: Sun, 28 Jun 2009 18:32:58 -0400
From: Stephen Frost <sfrost@snowman.net>
To: Alex Chiang <achiang@hp.com>
Cc: linux-kernel@vger.kernel.org, Daniel Frazier <daniel_frazier@hp.com>,
       David Altobelli <david.altobelli@hp.com>, nagananda.chumbalkar@hp.com
Subject: Re: ACPI issues on HP DL585 G2
Message-ID: <20090628223258.GP20436@tamriel.snowman.net>
References: <20090628034038.GK20436@tamriel.snowman.net> <20090628172052.GA13957@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvlH2BAVfmx8aXCn"
Content-Disposition: inline
In-Reply-To: <20090628172052.GA13957@ldl.fc.hp.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snowman.net
X-Operating-System: Linux/2.6.26-1-amd64 (x86_64)
X-Uptime: 18:32:33 up 17 days, 19:59, 23 users,  load average: 0.08, 0.07,
	0.07
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvlH2BAVfmx8aXCn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Alex Chiang (achiang@hp.com) wrote:
> I'm just scanning mail on the weekend, but what version of the
> BIOS are you on? Do you have the latest?

Check the message I just posted, it includes a dmesg under 2.6.30 (also
with noapic, since it didn't boot w/o it again).

	Stephen

--GvlH2BAVfmx8aXCn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpH75oACgkQrzgMPqB3kijLAwCffbzhmoMU6aTbkrGBRQ3Th8KL
diEAoIqTiPavQIF8NP5qmXNI3rmeUNWk
=h24V
-----END PGP SIGNATURE-----

--GvlH2BAVfmx8aXCn--
