Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbZF3BSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbZF3BSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 21:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZF3BS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 21:18:27 -0400
Received: from tamriel.snowman.net ([72.66.115.51]:33029 "EHLO
	tamriel.snowman.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbZF3BS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 21:18:27 -0400
Date: Mon, 29 Jun 2009 21:18:30 -0400
From: Stephen Frost <sfrost@snowman.net>
To: dann frazier <dannf@hp.com>
Cc: Alex Chiang <achiang@hp.com>, linux-kernel@vger.kernel.org,
       David Altobelli <david.altobelli@hp.com>, nagananda.chumbalkar@hp.com
Subject: Re: ACPI issues on HP DL585 G2
Message-ID: <20090630011830.GU20436@tamriel.snowman.net>
References: <20090628034038.GK20436@tamriel.snowman.net> <20090628172052.GA13957@ldl.fc.hp.com> <20090628223258.GP20436@tamriel.snowman.net> <20090630011541.GL22480@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FxQkOwrLuQ+yAGv2"
Content-Disposition: inline
In-Reply-To: <20090630011541.GL22480@ldl.fc.hp.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snowman.net
X-Operating-System: Linux/2.6.26-1-amd64 (x86_64)
X-Uptime: 21:17:25 up 18 days, 22:44, 24 users,  load average: 0.09, 0.07,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FxQkOwrLuQ+yAGv2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* dann frazier (dannf@hp.com) wrote:
> fyi, I tested an HP DL585 G2 w/ the same 2.6.30 kernel build
> and didn't have any problems. I am running the A07 3/11/2009 BIOS.
> dmesg output follows:

I did post updates including dmesg output from the problem box w/ ACPI
enabled and 'debug' on the cmdline.  If you'd like me to send them
directly to you also, just let me know.

	Thanks,

		Stephen

--FxQkOwrLuQ+yAGv2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpJZ+YACgkQrzgMPqB3kii4+wCdEjOUf0mFJHC7GjmJ4kcCE0dB
k4kAnjO9aTVh/gFCZ+Yyl8bisXmlU5b/
=R+05
-----END PGP SIGNATURE-----

--FxQkOwrLuQ+yAGv2--
