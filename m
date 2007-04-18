Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbXDRUIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbXDRUIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 16:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbXDRUIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 16:08:43 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:48726 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbXDRUIn (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 16:08:43 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: linux-kernel@vger.kernel.org
Subject: Stupid GIT question...
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1176926921_3554P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 18 Apr 2007 16:08:41 -0400
Message-ID: <20364.1176926921@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1176926921_3554P
Content-Type: text/plain; charset=us-ascii

I have a GIT tree (iwlwifi, but the problem is my idiocy, not the tree ;).

What's the command to get a diff of "what I would merge if I said 'git pull'?"
(similar to what 'cvs diff' does - AFAICT, 'git diff HEAD .' diffs my *current*
pull of the tree against itself and does nothing...


--==_Exmh_1176926921_3554P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGJnrJcC3lWbTT17ARAgrYAKCOPKR7EveIO/H36HhYG81nVAxHtACg2ErG
iYUu+pxzN3LWbc8uc+YHWJ8=
=yGih
-----END PGP SIGNATURE-----

--==_Exmh_1176926921_3554P--
