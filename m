Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbYLMGUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbYLMGUp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 01:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbYLMGUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 01:20:33 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40205 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYLMGUc (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 01:20:32 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: nab@kernel.org
Cc: linux-iscsi-target-dev@googlegroups.com,
       LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Announce]: Target_Core_Mod/ConfigFS and LIO-Target v3.0 work
In-Reply-To: Your message of "Fri, 12 Dec 2008 01:40:09 PST."
             <1229074809.4153.666.camel@haakon2.linux-iscsi.org>
From: Valdis.Kletnieks@vt.edu
References: <1228965271.4153.510.camel@haakon2.linux-iscsi.org> <e2e108260812111124j79793adcie106ac2da4f801f3@mail.gmail.com> <1229025513.4153.542.camel@haakon2.linux-iscsi.org> <e2e108260812112321w2f5b1827xe2593888e44808ae@mail.gmail.com>
            <1229074809.4153.666.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1229149205_5220P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 13 Dec 2008 01:20:05 -0500
Message-ID: <54939.1229149205@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1229149205_5220P
Content-Type: text/plain; charset=us-ascii

On Fri, 12 Dec 2008 01:40:09 PST, "Nicholas A. Bellinger" said:

> Too bad, because you are missing out on the most advanced ConfigFS
> enabled storage engine on the planet.

OK. I *have* to ask.. ;)

What's the *second* most advanced configfs-enabled storage engine?

The only in-tree users of configfs I could find (grepping for the string
'config_item_init') were drivers/net/netconsole, fs/ocfs2, and fs/dlm, so
"most advanced configfs" is well into "world's tallest midget" territory...


--==_Exmh_1229149205_5220P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJQ1QVcC3lWbTT17ARAsLvAJ9TgmKJWibx7r07q0n/9GMXzdMt6QCg9Pp3
DqSw5MXxkSTYuk9voWPx8D4=
=e6vE
-----END PGP SIGNATURE-----

--==_Exmh_1229149205_5220P--
