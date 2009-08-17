Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbZHQIGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbZHQIGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbZHQIGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:06:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42868 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757268AbZHQIGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:06:16 -0400
Date: Mon, 17 Aug 2009 18:06:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <sfi-devel@simplefirmware.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>
Subject: linux-next: manual merge of the sfi tree with the acpi tree
Message-Id: <20090817180610.0de34cab.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__17_Aug_2009_18_06_10_+1000_orMxWP_nFfo6rrx6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Aug_2009_18_06_10_+1000_orMxWP_nFfo6rrx6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the sfi tree got a conflict in
drivers/acpi/tables.c between commit
44043a4299724bb386ac7915a57a18b176e9df07 ("ACPI: check acpi_disabled in
acpi_table_parse()") from the acpi tree and commit
55ec50ee899aa3199c126bb4b740abb9a4ab51df ("ACPI: check acpi_disabled in
acpi_table_parse() and acpi_table_parse_entries()") from the sfi tree.

I used the sfi tree version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__17_Aug_2009_18_06_10_+1000_orMxWP_nFfo6rrx6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqJD3IACgkQjjKRsyhoI8ylcgCgqXMnR740dNXds3nLSwQP4IYQ
kAoAniGAQjUOTijQmAZrXIuta4iLlo8a
=j2QE
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Aug_2009_18_06_10_+1000_orMxWP_nFfo6rrx6--
