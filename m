Return-Path: <linux-kernel-owner+w=401wt.eu-S965533AbXDVJLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965533AbXDVJLp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 05:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965537AbXDVJLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 05:11:45 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:48235 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965533AbXDVJLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 05:11:44 -0400
Date: Sun, 22 Apr 2007 10:39:41 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] Allow reading tainted flag as user
Message-ID: <20070422083941.GA7945@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The commit 34f5a39899f3f3e815da64f48ddb72942d86c366 restricted reading
of the tainted value. The attached patch changes this back to a
write-only check and restores the read behaviour of older versions.

Signed-off-by: Bastian Blank <bastian@waldi.eu.org>

--=20
The joys of love made her human and the agonies of love destroyed her.
		-- Spock, "Requiem for Methuselah", stardate 5842.8

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEARECAAYFAkYrH0wACgkQnw66O/MvCNEeIQCfVfr7WewodSN9BUxbaoSKaTCF
NgAAn3jxCYcFJYcE5PO+0yiw7If+AhNt
=xRWz
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
