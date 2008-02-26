Return-Path: <linux-kernel-owner+w=401wt.eu-S1762848AbYBZTHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762848AbYBZTHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 14:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYBZTHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 14:07:43 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34649 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbYBZTHm (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 14:07:42 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: rzryyvzy <rzryyvzy@trashmail.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is there a memory block device?
In-Reply-To: Your message of "Tue, 26 Feb 2008 19:53:36 +0100."
             <20080226185336.9771B58477AE1@trashmail.net>
From: Valdis.Kletnieks@vt.edu
References: <20080226185336.9771B58477AE1@trashmail.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1204052858_3303P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 26 Feb 2008 14:07:38 -0500
Message-ID: <4790.1204052858@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1204052858_3303P
Content-Type: text/plain; charset=us-ascii

On Tue, 26 Feb 2008 19:53:36 +0100, rzryyvzy said:
> I know that tmpfs is a memmory filesystem. Is there a possibility to create also a memory block device?
> Is there a possibility to create for example a 1 GB memory block device (from the RAM)?

A better question would be:

What problem are you trying to solve by ysing a "memory block device"?  There
may well be other approaches that would work better, but it's hard to say.
Are you trying to avoid the buffer cache pool?  Ensure pages are in physical
memory? Or some other problem?

--==_Exmh_1204052858_3303P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHxGN6cC3lWbTT17ARAldFAJ44Z9B0wfPEzfqkQDb/ozwEv5kxQgCg8ov9
Rdfgn91if6OD1yklRV5IXM8=
=Dn8O
-----END PGP SIGNATURE-----

--==_Exmh_1204052858_3303P--
