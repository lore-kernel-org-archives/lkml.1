Return-Path: <linux-kernel-owner+w=401wt.eu-S1760588AbZD2TYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588AbZD2TYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758911AbZD2TX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:23:58 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36938 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759594AbZD2TX5 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:23:57 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Mario Limonciello <mario_limonciello@dell.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add support for more dell-wmi hotkeys
In-Reply-To: Your message of "Wed, 29 Apr 2009 19:31:54 BST."
             <20090429183154.GC2325@srcf.ucam.org>
From: Valdis.Kletnieks@vt.edu
References: <49ECBAE2.2080308@dell.com> <49EE09D9.2060209@dell.com> <20090429165729.GB32619@srcf.ucam.org> <49F89981.10806@dell.com>
            <20090429183154.GC2325@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1241033029_4397P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 29 Apr 2009 15:23:49 -0400
Message-ID: <36672.1241033029@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1241033029_4397P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <36666.1241033029.1@turing-police.cc.vt.edu>

On Wed, 29 Apr 2009 19:31:54 BST, Matthew Garrett said:
> It's a precision M6300 - I'm afraid I'm not sure what BIOS it's running.

This works on Latitudes and Optiplexes, should be good for Precision as well:

# dmidecode | grep -C 5 'BIOS Info'

should get you (somewhere) this:

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
        Vendor: Dell Inc.
        Version: A09
        Release Date: 06/04/2008


--==_Exmh_1241033029_4397P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ+KlFcC3lWbTT17ARAkzWAKDa/As+kYSKrP9bSpyC0XG7pwn2NwCaA78w
zdLfV4QJvi+Tvmdv1h9yUGA=
=BMMZ
-----END PGP SIGNATURE-----

--==_Exmh_1241033029_4397P--
