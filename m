Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbXDCXXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbXDCXXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbXDCXXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:23:09 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35191 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbXDCXXI (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:23:08 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc5-mm4
In-Reply-To: Your message of "Wed, 04 Apr 2007 00:58:26 +0200."
             <20070404005826.5c849ab6@werewolf-wl>
From: Valdis.Kletnieks@vt.edu
References: <20070402224745.71a25af7.akpm@linux-foundation.org> <20070404004005.2f21d514@werewolf-wl> <20070403155135.ff7f3043.akpm@linux-foundation.org>
            <20070404005826.5c849ab6@werewolf-wl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175642567_7609P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 03 Apr 2007 19:22:47 -0400
Message-ID: <17464.1175642567@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175642567_7609P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 Apr 2007 00:58:26 +0200, "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" said:

> Anyways, I have just remembered I use the (in)famous nVidia driver.
> Will try to reproduce without it. This was more like a probe to see if
> somebody else is suffering it...

The nVidia driver will get some truly astounding indigestion if you accidentally
upgrade your xorg userspace libraries and forget to re-install the nVidia
userspace.  Is that what's biting you?


--==_Exmh_1175642567_7609P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGEuHHcC3lWbTT17ARAhX1AKC9AFjS3UzUTPIx5FyaAl4/Z/gWsgCfaX6u
Fj2SdFddj3+ifrKTOFPXY7U=
=2QOo
-----END PGP SIGNATURE-----

--==_Exmh_1175642567_7609P--
