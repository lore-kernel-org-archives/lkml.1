Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbZF3CGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbZF3CGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 22:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZF3CGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 22:06:42 -0400
Received: from tamriel.snowman.net ([72.66.115.51]:45977 "EHLO
	tamriel.snowman.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbZF3CGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 22:06:42 -0400
Date: Mon, 29 Jun 2009 22:06:44 -0400
From: Stephen Frost <sfrost@snowman.net>
To: dann frazier <dannf@dannf.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Alex Chiang <achiang@hp.com>,
       linux-kernel@vger.kernel.org, David Altobelli <david.altobelli@hp.com>,
       nagananda.chumbalkar@hp.com
Subject: Re: ACPI issues on HP DL585 G2
Message-ID: <20090630020644.GW20436@tamriel.snowman.net>
References: <20090628034038.GK20436@tamriel.snowman.net> <20090628172052.GA13957@ldl.fc.hp.com> <20090628223258.GP20436@tamriel.snowman.net> <20090630011541.GL22480@ldl.fc.hp.com> <20090630011709.GT20436@tamriel.snowman.net> <86802c440906291847p302d47eau1d1cbd07be59c61@mail.gmail.com> <20090630015140.GV20436@tamriel.snowman.net> <20090630015302.GN22480@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4kYG1Ol6LYbfFhUk"
Content-Disposition: inline
In-Reply-To: <20090630015302.GN22480@ldl.fc.hp.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snowman.net
X-Operating-System: Linux/2.6.26-1-amd64 (x86_64)
X-Uptime: 21:54:19 up 18 days, 23:21, 22 users,  load average: 0.00, 0.05,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4kYG1Ol6LYbfFhUk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* dann frazier (dannf@dannf.org) wrote:
> What about your other working DL585 boxes? Are they G2's, and are they
> also using P600s?

The other DL585 G2 that I've got with the latest BIOS/etc, running under
2.6.29, has a P800 installed, and it's working fine.  Actually, the
other DL585 G2's that we had problems running something newer than
2.6.22 on also had P600's..  It was quite a while ago that we tried to
upgrade those (around 2.6.26), but I'm guessing if we tried now we'd hit
the same issue.

Don't suppose you can grab a P600 from somewhere and try?

	Thanks,

		Stephen

--4kYG1Ol6LYbfFhUk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpJczQACgkQrzgMPqB3kii82QCeNsUKIlZM0jZMwCBBWhkmHAGK
ywQAnjjyflTDwi9bzqauBO2Hwpar57ho
=O/cH
-----END PGP SIGNATURE-----

--4kYG1Ol6LYbfFhUk--
