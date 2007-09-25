Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbXIYQot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbXIYQot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbXIYQom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:44:42 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33805 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbXIYQol (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:44:41 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: linux-kernel@vger.kernel.org
Subject: Odd kprobes question...
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190738680_3926P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Sep 2007 12:44:40 -0400
Message-ID: <5650.1190738680@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190738680_3926P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <5496.1190738655.1@turing-police.cc.vt.edu>

2.6.23-rc8-mm1, x86_64.

# ls -l /sys/kernel/debug/kprobes/
total 0
-rw------- 1 root root 0 2007-09-25 12:21 enabled
-r--r--r-- 1 root root 0 2007-09-25 12:21 list

Is there a reason 'enabled' is mod 0600 instead of 0644, when 'list' is 444
and allows you to figure out (indirectly) if it's enabled?


--==_Exmh_1190738680_3926P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG+Tr4cC3lWbTT17ARAibrAJwO0Gr5092zLw9z4FsmXz9HSWMMywCfcsTy
KI7ReS4cAwJUY/JEnmiZOmk=
=NStb
-----END PGP SIGNATURE-----

--==_Exmh_1190738680_3926P--
