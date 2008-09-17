Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbYIQF3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbYIQF3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 01:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbYIQF3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 01:29:08 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57854 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbYIQF3H (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 01:29:07 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: gshan <gshan@alcatel-lucent.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: how to change priority of telnet session
In-Reply-To: Your message of "Wed, 17 Sep 2008 11:40:31 +0800."
             <48D07C2F.2040500@alcatel-lucent.com>
From: Valdis.Kletnieks@vt.edu
References: <48D07C2F.2040500@alcatel-lucent.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1221629343_32017P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Sep 2008 01:29:03 -0400
Message-ID: <32251.1221629343@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1221629343_32017P
Content-Type: text/plain; charset=us-ascii

On Wed, 17 Sep 2008 11:40:31 +0800, gshan said:
> Hi All,
> 
> I'm using telnetd which was started by xinetd. The current default 
> priority of telnetd isn't high enough,

1) That's not a kernel issue, that's a userspace configuration issue, probably
best asked on a mailing list for administration of whatever distribution of
Linux you're using.

2) There's a fairly high likelyhood that your real problem isn't that telnet's
priority is too low, because telnet is a fairly lightweight process and *should*
behave fairly well unless there's major system tuning issues - and if that's
the case, there's probably *better* ways to fix the problem.  What problem are
you trying to solve by changing telnet's priority?

--==_Exmh_1221629343_32017P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI0JWfcC3lWbTT17ARAlG/AKDuCW3twSoJpPPVt1LUHoGodQTlBgCggZcA
VaDvof4h5F2nRTMvEFncyxA=
=Sdy2
-----END PGP SIGNATURE-----

--==_Exmh_1221629343_32017P--
