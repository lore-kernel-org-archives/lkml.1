Return-Path: <linux-kernel-owner+w=401wt.eu-S1762093AbXETE66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762093AbXETE66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 00:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760132AbXETE6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 00:58:43 -0400
Received: from dsl-66-59-230-166.static.linkline.com ([66.59.230.166]:38246
	"EHLO merry.kedzierski.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759616AbXETE6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 00:58:42 -0400
X-Greylist: delayed 2667 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 May 2007 00:58:42 EDT
Date: Sat, 19 May 2007 18:30:04 -0700 (PDT)
From: Artur Kedzierski <artur@kedzierski.org>
To: linux-kernel@vger.kernel.org
Subject: Re: This kernel requires the following features not present on the
 CPU... (on a VIA C7 CPU)
Message-ID: <Pine.LNX.4.64.0705191820100.11197@merry.kedzierski.org>
X-GPG-PUBLIC_KEY: http://www.kedzierski.org/artur-pubkey.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


 	I purchased C7 VIA Esther and I experience similar problem with
random crashes. There is also a thread on Via Arena about "J7F4K - Hard 
Lockups" where people describe the same issue:
http://forums.viaarena.com/messageview.aspx?catid=28&threadid=77032
 	I've tried the following kernels:
2.6.21.1 - crashes pretty quick
2.6.21.1 with disabled CPU scaling - better mileage but still crashes
2.6.22-rc1 - hangs on boot
2.6.22-rc1-mm1 - doesn't compile
2.6.22-rc2 - hangs on boot
 	I've ran memtest86 and no memory problems were found.
 	Any ideas or suggestions?
 	Thank You.

=================================================================
Artur Kedzierski                    || Artur@Kedzierski.org


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGT6SdJzjfxpUNGawRAqPzAJ921Rk67oA+H28hilXkqqUTIcF60QCghI69
LLLVhIpwQjN5nTsriGfC2M0=
=rG40
-----END PGP SIGNATURE-----
