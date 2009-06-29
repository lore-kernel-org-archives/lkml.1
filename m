Return-Path: <linux-kernel-owner+w=401wt.eu-S1756468AbZF2B5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468AbZF2B5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 21:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZF2B5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 21:57:37 -0400
Received: from tamriel.snowman.net ([72.66.115.51]:58311 "EHLO
	tamriel.snowman.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbZF2B5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 21:57:36 -0400
Date: Sun, 28 Jun 2009 21:57:38 -0400
From: Stephen Frost <sfrost@snowman.net>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ACPI issues on HP DL585 G2
Message-ID: <20090629015738.GQ20436@tamriel.snowman.net>
References: <20090628034038.GK20436@tamriel.snowman.net> <86802c440906272126s7d3b97afh16069280bd297827@mail.gmail.com> <20090628223132.GO20436@tamriel.snowman.net> <86802c440906281849m51ab3c82u84d76a1aaceba2ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WkmTq0Xj5pNQBic9"
Content-Disposition: inline
In-Reply-To: <86802c440906281849m51ab3c82u84d76a1aaceba2ef@mail.gmail.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snowman.net
X-Operating-System: Linux/2.6.26-1-amd64 (x86_64)
X-Uptime: 21:52:16 up 17 days, 23:19, 19 users,  load average: 0.16, 0.17,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WkmTq0Xj5pNQBic9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Yinghai Lu (yhlu.kernel@gmail.com) wrote:
> are you sure these two come from same BIOS ?

They might not..  I did upgrade the BIOS to the latest revision and I
don't recall if the last 2.6.22 boot was before or after the BIOS
upgrade.  The 2.6.29 and 2.6.30 boots (both w/o APIC) are from the same
BIOS.  Would it help to try booting under 2.6.22 with the BIOS that's on
there now?

Is there some other information I could provide while the machine is
running?  Unfortunately, this is a rather important box for us.

	Thanks,

		Stephen

--WkmTq0Xj5pNQBic9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpIH5IACgkQrzgMPqB3kiheIACgifhnp5Cr4CKo062uFl82+goN
swgAnjd67g0a9O0Mbw6J0CEpsjkvDbkG
=piWN
-----END PGP SIGNATURE-----

--WkmTq0Xj5pNQBic9--
