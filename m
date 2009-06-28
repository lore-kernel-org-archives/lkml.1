Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbZF1Rfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbZF1Rfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 13:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZF1Rfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 13:35:43 -0400
Received: from tamriel.snowman.net ([72.66.115.51]:48344 "EHLO
	tamriel.snowman.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbZF1Rfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 13:35:42 -0400
Date: Sun, 28 Jun 2009 13:35:44 -0400
From: Stephen Frost <sfrost@snowman.net>
To: Alex Chiang <achiang@hp.com>
Cc: linux-kernel@vger.kernel.org, Daniel Frazier <daniel_frazier@hp.com>,
       David Altobelli <david.altobelli@hp.com>, nagananda.chumbalkar@hp.com
Subject: Re: ACPI issues on HP DL585 G2
Message-ID: <20090628173544.GM20436@tamriel.snowman.net>
References: <20090628034038.GK20436@tamriel.snowman.net> <20090628172052.GA13957@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gkQsIeIyLzf1kMz9"
Content-Disposition: inline
In-Reply-To: <20090628172052.GA13957@ldl.fc.hp.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snowman.net
X-Operating-System: Linux/2.6.26-1-amd64 (x86_64)
X-Uptime: 13:30:35 up 17 days, 14:57, 19 users,  load average: 0.29, 0.12,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gkQsIeIyLzf1kMz9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Alex Chiang (achiang@hp.com) wrote:
> I'm just scanning mail on the weekend, but what version of the
> BIOS are you on? Do you have the latest?

Yes, I upgraded using the 8.5 CD before trying 2.6.29 (again).  I do see
a commit included in 2.6.30 which appears to address what Yinghai Lu
pointed out in his mail.  I'm going to try and test 2.6.30 today or
tomorrow.

BTW, it'd be nice if the firmware update CD was either shown under every
OS, or if it was somehow at the level before the OS selection, was
annoyingly difficult to find since it wasn't under the Debian OS link.
:)

	Thanks,

		Stephen

--gkQsIeIyLzf1kMz9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpHqfAACgkQrzgMPqB3kih6VQCdH+Mdua1z4KD1tAz+Qb5Cyl46
yAIAn2+7piLcmOoK11CL9SupS5t+ERRH
=JAkX
-----END PGP SIGNATURE-----

--gkQsIeIyLzf1kMz9--
