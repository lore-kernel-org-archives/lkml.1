Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbXCHR5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbXCHR5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932370AbXCHR5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:57:04 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34876 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbXCHR5D (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:57:03 -0500
Message-Id: <200703081756.l28HuwDD016018@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm1
In-Reply-To: Your message of "Wed, 07 Mar 2007 20:18:39 PST."
             <20070307201839.6f45735b.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070307201839.6f45735b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1173376618_10421P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Mar 2007 12:56:58 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1173376618_10421P
Content-Type: text/plain; charset=us-ascii

On Wed, 07 Mar 2007 20:18:39 PST, Andrew Morton said:
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc3/2.6.21-rc3-mm1/

Mostly working for me.

> - The wireless changes in here need a lot of testers, please.  It is major
>   rework.

Working on it - the new MAC80211 stack landed in the -mm tree, but the matching
iwlwifi driver for the Intel 3945ABG is still out-of-tree and acting wonky
for me.  The card comes up, 'iwlist scanning' sees 4 access points, but it
won't associate.  Not sure what I borked up.

--==_Exmh_1173376618_10421P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF8E5qcC3lWbTT17ARAskJAKCnwMX+7BwBCgZfDKDHxoIoV7OvMwCfR0Hf
FxdW42be1n+V87jTXBYTmHs=
=Li6F
-----END PGP SIGNATURE-----

--==_Exmh_1173376618_10421P--
