Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbYKZRua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbYKZRua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbYKZRuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:50:22 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52448 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbYKZRuV (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:50:21 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-rc6-mmotm1126 - BUG in disk quota code
In-Reply-To: Your message of "Wed, 26 Nov 2008 17:49:06 +0100."
             <20081126164906.GG23124@duck.suse.cz>
From: Valdis.Kletnieks@vt.edu
References: <4270.1227716433@turing-police.cc.vt.edu>
            <20081126164906.GG23124@duck.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1227721812_3730P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Nov 2008 12:50:13 -0500
Message-ID: <3893.1227721813@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1227721812_3730P
Content-Type: text/plain; charset=us-ascii

On Wed, 26 Nov 2008 17:49:06 +0100, Jan Kara said:
> On Wed 26-11-08 11:20:33, Valdis.Kletnieks@vt.edu wrote:
> > System blew out when /etc/rc.sysinit did a 'quotaon -a'.  Not sure which
> > of the many quota-related commits in linux-next.patch or in -mm did this...
>   Thanks for report. Already hit it myself and Mark should have the fix in
> his tree (I sent it to him yesterday) so it should propagate into -mm
> quickly.

Good enough - I'll wait for Andrew to drop the next -mmotm, and I'll
yell if it's still broken then...


--==_Exmh_1227721812_3730P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJLYxUcC3lWbTT17ARArqqAKCOK/HQzySAUCrH0tpXfCHagiueKACfT3qI
oY4ygjgeT4V+GGQCeeMlMGs=
=+h1S
-----END PGP SIGNATURE-----

--==_Exmh_1227721812_3730P--
