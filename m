Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbYAPFI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbYAPFI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 00:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYAPFIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 00:08:17 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36885 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbYAPFIQ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 00:08:16 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: ric@emc.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Abhishek Rai <abhishekrai@google.com>, linux-kernel@vger.kernel.org,
       rohitseth@google.com, linux-ext4@vger.kernel.org
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.24-rc6 -mm patch]
In-Reply-To: Your message of "Tue, 15 Jan 2008 10:09:16 EST."
             <478CCC9C.4070507@emc.com>
From: Valdis.Kletnieks@vt.edu
References: <200801140839.01986.abhishekrai@google.com> <20080114163412.83a8b18d.akpm@linux-foundation.org> <20080115030441.a0270609.akpm@linux-foundation.org>
            <478CCC9C.4070507@emc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1200460088_2966P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 16 Jan 2008 00:08:08 -0500
Message-ID: <27941.1200460088@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1200460088_2966P
Content-Type: text/plain; charset=us-ascii

On Tue, 15 Jan 2008 10:09:16 EST, Ric Wheeler said:
> I actually think that the value of this kind of reduction is huge. We 
> have seen fsck run for days (not just hours) which makes the "restore 
> from backup" versus "fsck" decision favor the tapes...

Funny thing is that for many of these sorts of cases, "restore from backup"
is *also* a "days" issue unless you do a *lot* of very clever planning
ahead to be able to get multiple tape drives moving at the same time while
not causing issues at the receiving end either....




--==_Exmh_1200460088_2966P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHjZE4cC3lWbTT17ARAoATAJ9121kFAZ7spB4tgg+8Ih4vIJIyWgCfZunO
yiiJqYswZVGzfvudcB5Ko5M=
=/EUP
-----END PGP SIGNATURE-----

--==_Exmh_1200460088_2966P--
