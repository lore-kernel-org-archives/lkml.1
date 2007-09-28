Return-Path: <linux-kernel-owner+w=401wt.eu-S1761353AbXI1J2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761353AbXI1J2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759375AbXI1J2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:28:20 -0400
Received: from mailbackup.inode.at ([213.229.60.24]:60195 "EHLO
	mailbackup.inode.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759019AbXI1J2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:28:19 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2007 05:28:19 EDT
Message-ID: <46FCC7A2.8090506@detonation.org>
Date: Fri, 28 Sep 2007 11:21:38 +0200
From: Stefan Seifert <nine@detonation.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.6) Gecko/20070803 SUSE/1.1.4-17 SeaMonkey/1.1.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Hannes Dorbath <light@theendofthetunnel.de>
CC: Laurent CARON <lcaron@lncsa.com>, linux-kernel@vger.kernel.org,
       drbd-user@linbit.com
Subject: Re: [DRBD-user] Crash on 2.6.22
References: <46FCC2BE.7020509@lncsa.com> <46FCC3E4.7030908@theendofthetunnel.de>
In-Reply-To: <46FCC3E4.7030908@theendofthetunnel.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hannes Dorbath wrote:
> On 28.09.2007 11:00, Laurent CARON wrote:
>> The $HOME directories are stored on a drbd (version: 0.7.24
>> (api:79/proto:74)) partition (with an XFS filesystem).
> 
> Was the deadlock with 2.6.22 only in 0.8.x? Is 0.7.x fine with 2.6.22?

The deadlock also occures with 0.7.x. A patch for that is floating around.

Regards,
Stefan Seifert

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFG/Meh1QuEJQQMVrgRAsJxAJ46+//VfKIxFBmauhsXdq0DFpo6wQCeOuHa
clUidp3JcwzW8ZDGeFdAXhM=
=xD65
-----END PGP SIGNATURE-----
