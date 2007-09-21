Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbXIUODR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbXIUODR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbXIUODD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:03:03 -0400
Received: from enterprise.ram.RWTH-Aachen.DE ([137.226.68.2]:59156 "EHLO
	enterprise.ram.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049AbXIUODB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:03:01 -0400
X-Greylist: delayed 1306 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Sep 2007 10:03:01 EDT
Date: Fri, 21 Sep 2007 15:41:04 +0200
From: markus reichelt <ml@mareichelt.de>
To: linux-kernel@vger.kernel.org
Subject: ACPI question: Incorrect checksum.
Message-ID: <20070921134104.GB3863@tatooine.rebelbase.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uQr8t48UFsdbeI+V"
Content-Disposition: inline
Organization: still stuck in reorganization mode
X-PGP-Key: 0xC2A3FEE4
X-PGP-Fingerprint: FFB8 E22F D2BC 0488 3D56  F672 2CCC 933B C2A3 FEE4
X-Request-PGP: http://mareichelt.de/keys/c2a3fee4.asc
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--uQr8t48UFsdbeI+V
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I noticed the following line in dmesg output with 23-rcX kernels


ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -
5E, should be 31 [20070126]


Before I start investigating the issue I wonder: Is this something
serious or just a minor issue? My system works just fine so far
(normal usage, 23.rc2-rc7).

--=20
left blank, right bald

--uQr8t48UFsdbeI+V
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG88nwLMyTO8Kj/uQRAhIWAJ9pTYe3IdV65kju6PmNt/+eIy6vQgCfQFRf
uS8s4dWGhN1uhAmr/jZexp8=
=9AwI
-----END PGP SIGNATURE-----

--uQr8t48UFsdbeI+V--
