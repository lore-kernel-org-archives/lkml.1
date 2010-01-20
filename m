Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567Ab0ATCCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab0ATCCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 21:02:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842Ab0ATCCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 21:02:09 -0500
Received: from trinity.fluff.org ([89.16.178.74]:58646 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033Ab0ATCCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 21:02:08 -0500
Date: Wed, 20 Jan 2010 02:02:02 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: linux-arm-kernel@lists.infradead.org,
       Linux Samsung SoC <linux-samsung-soc@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: git pre-commit hook running checkpatch.pl
Message-ID: <20100120020202.GE26562@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I've written a git pre-commit[1] hook which stops any commits happening if
checkpatch.pl reports problems with the patch. Any comments?

[1] http://www.fluff.org/ben/linux/githooks/pre-commit

--=20
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.


--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFLVmQaJZCApG2L7OYRAoX+AJ9nPRUmdDpLmJ+Uj1Nst/f1bQswrQCcC7gq
RFWd5CyZXe4O7WzLvYSwpZ8=
=JC9a
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
