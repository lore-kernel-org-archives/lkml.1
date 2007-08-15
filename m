Return-Path: <linux-kernel-owner+w=401wt.eu-S1764349AbXHOPNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764349AbXHOPNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 11:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760174AbXHOPNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 11:13:10 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34029 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758483AbXHOPNI (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 11:13:08 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: gshan <gshan@alcatel-lucent.com>
Cc: Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org
Subject: Re: do_coredump and O_NOFOLLOW
In-Reply-To: Your message of "Wed, 15 Aug 2007 16:03:39 +0800."
             <46C2B35B.5080709@alcatel-lucent.com>
From: Valdis.Kletnieks@vt.edu
References: <E1ILCwJ-0003th-00@calista.eckenfels.net>
            <46C2B35B.5080709@alcatel-lucent.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187190778_3177P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 15 Aug 2007 11:12:58 -0400
Message-ID: <5140.1187190778@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187190778_3177P
Content-Type: text/plain; charset=us-ascii

On Wed, 15 Aug 2007 16:03:39 +0800, gshan said:

> Bernd, Thanks for your reply. I don't think there are any hostile users 
> on the system. So it's relatively of security. I didn't hear of coreadm 
> tool before, Linux will become more powerful with coreadm.

Well, *right now* you don't have hostile users.  However, that can change, if a
user's password gets compromised (often because they left it on a stick-it note
on the monitor), or if somebody is running Firefox and accidentally hits a
malicious site that exploits a Firefox bug, or if one of your company's
employees didn't get the raise they wanted, so they're quitting and planning to
kill the system on their way out the door....


--==_Exmh_1187190778_3177P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGwxf6cC3lWbTT17ARAvARAJ9fMK1nRTt7QEfE4BUWsQUTSBEmuQCgwAaB
neGO0XN9sUoGcXGT9TmBYY0=
=9wlH
-----END PGP SIGNATURE-----

--==_Exmh_1187190778_3177P--
