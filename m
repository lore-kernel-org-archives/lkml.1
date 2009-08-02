Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbZHBTq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbZHBTq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZHBTq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:46:56 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:33998 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbZHBTqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:46:48 -0400
Subject: [ANNOUNCE] upstart 0.6.3 released
From: Scott James Remnant <scott@netsplit.com>
To: upstart-devel@lists.ubuntu.com
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MYL38SiMNFBYVi+KnHvg"
Date: Sun, 02 Aug 2009 20:46:38 +0100
Message-Id: <1249242398.32323.9.camel@wing-commander>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MYL38SiMNFBYVi+KnHvg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The biggest disadvantage to people actually using your software is that
they find bugs, this one's a doozy because it looks like it affects
older 0.3 releases as well.  Now seems as good a time as any to repeat
my recommendation that distributions, mobile and embedded appliance
developers using Upstart consider using 0.6 in their next release rather
than sticking with 0.3

I've also today created the 0.6 stable branch in bzr, those following
stable releases with bzr will want to update their trees to
lp:~scott/upstart/0.6.  New stable releases will be made off this branch
while trunk receives more exciting developments.


0.6.3  2009-08-02  "Our last, best hope for peace"

	* Fixed an assertion when a job's main process is terminated
	  while in the stopping state.  (Bug: #406408)

	* Fixed compilation on ia64.

	* nih-dbus-tool(1) manpage will not be installed, since the binary
	  is not.  (Bug: #403103)


The tarball can be found here:

	http://upstart.ubuntu.com/download/

For more information on upstart:

	http://upstart.ubuntu.com/


Scott
--=20
Have you ever, ever felt like this?
Had strange things happen?  Are you going round the twist?

--=-MYL38SiMNFBYVi+KnHvg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkp17R4ACgkQIexP3IStZ2wl5QCfYpRdKwNH+LzVC4H3RXDwZwQ8
FCAAn3J7sQpfMjhWsBZfdN4aU7+/KKfi
=5zo7
-----END PGP SIGNATURE-----

--=-MYL38SiMNFBYVi+KnHvg--

