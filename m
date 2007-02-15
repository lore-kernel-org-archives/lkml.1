Return-Path: <linux-kernel-owner+w=401wt.eu-S1161198AbXBOUfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161198AbXBOUfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161200AbXBOUfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:35:07 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42712 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161198AbXBOUfG (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:35:06 -0500
Message-Id: <200702152034.l1FKYS93012172@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       herbert.xu@redhat.com, linux-kernel@vger.kernel.org,
       arjan@infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
In-Reply-To: Your message of "Wed, 14 Feb 2007 22:14:53 PST."
             <200702142214.53625.agruen@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <200702142135.40832.agruen@suse.de> <20070215054559.GD15654@redhat.com>
            <200702142214.53625.agruen@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1171571668_27755P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 15 Feb 2007 15:34:28 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1171571668_27755P
Content-Type: text/plain; charset=us-ascii

On Wed, 14 Feb 2007 22:14:53 PST, Andreas Gruenbacher said:
> I agree, that's really what should happen. We solve this by marking modules as
> supported, partner supported, or unsupported, but in an "insecure" way, so
> partners and users could try to fake the support status of a module and/or
> remove status flags from Oopses, and cryptography wouldn't save us.

Where cryptography *can* save you is that a partner or user can't fake a
'Suse Supported' signature without access to the Suse private key.

--==_Exmh_1171571668_27755P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF1MPUcC3lWbTT17ARAh66AJ9Gzvgd0zhuDVcrNqFTnRB2GRzatwCeLVDf
kNp5hrMChhmnQIr5y+0Zehg=
=5kzR
-----END PGP SIGNATURE-----

--==_Exmh_1171571668_27755P--
