Return-Path: <linux-kernel-owner+w=401wt.eu-S1751921AbXE2VR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbXE2VR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbXE2VRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:17:20 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:60332 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbXE2VRU (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:17:20 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Toshiharu Harada <haradats@gmail.com>, James Morris <jmorris@namei.org>,
       casey@schaufler-ca.com, Andreas Gruenbacher <agruen@suse.de>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
In-Reply-To: Your message of "Mon, 28 May 2007 21:54:46 EDT."
             <69A10107-78FE-4F11-AF52-9B8F648AFC0A@mac.com>
From: Valdis.Kletnieks@vt.edu
References: <309300.41401.qm@web36615.mail.mud.yahoo.com> <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com> <Line.LNX.4.64.0705261442000.23020@d.namei> <9d732d950705261608j4bc72cd4s4378df9848101c84@mail.gmail.com> <EC769668-ED57-4D6D-80B2-1BFD039E113C@mac.com> <9d732d950705270025p1bedae23ne137f024eb78886f@mail.gmail.com> <4F828E03-DA6B-484E-A8F2-885D1BC6F23E@mac.com> <9d732d950705280341x78575d85kaf95b0e2884723f3@mail.gmail.com>
            <69A10107-78FE-4F11-AF52-9B8F648AFC0A@mac.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1180473430_6594P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 29 May 2007 17:17:10 -0400
Message-ID: <8219.1180473430@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1180473430_6594P
Content-Type: text/plain; charset=us-ascii

On Mon, 28 May 2007 21:54:46 EDT, Kyle Moffett said:

> Average users are not supposed to be writing security policy.  To be  
> honest, even average-level system administrators should not be  
> writing security policy.  It's OK for such sysadmins to tweak  
> existing policy to give access to additional web-docs or such, but  
> only expert sysadmin/developers or security professionals should be  
> writing security policy.  It's just too damn easy to get completely  
> wrong.

The single biggest challenge in computer security at the present time is how to
build *and deploy* servers that stay reasonably secure even when run by the
average wave-a-dead-chicken sysadmin, and desktop-class boxes that can survive
the best attempts of Joe Sixpack's "Ooh shiny" reflex, and Joe's kid's attempts
to evade the nannyware that Joe had somebody install.

(If you know how to build such things, don't bother replying.  If you have
actual field experience on getting significant percents of Joe Sixpacks to
switch, I need to buy you a beer or something.. ;)




--==_Exmh_1180473430_6594P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGXJhWcC3lWbTT17ARAq2DAJwNFUUhxWyqCuzlLlpqE43mqV4itACg3ZK2
oHkqCdmiR4Fxr6ilL9FxvNs=
=yoOC
-----END PGP SIGNATURE-----

--==_Exmh_1180473430_6594P--
