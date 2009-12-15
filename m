Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbZLOH11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbZLOH11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 02:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbZLOH1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 02:27:25 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:64085 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbZLOH1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 02:27:24 -0500
Message-ID: <4B273A32.5020407@monstr.eu>
Date: Tue, 15 Dec 2009 08:26:42 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Li Hong <lihong.hi@gmail.com>,
       Wu Zhangjin <wuzhangjin@gmail.com>
Subject: Re: linux-next: manual merge of the mips tree with Linus' tree
References: <20091215102046.6fc8faa8.sfr@canb.auug.org.au>
In-Reply-To: <20091215102046.6fc8faa8.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Ralf,
> 
> Today's linux-next merge of the mips tree got a conflict in
> scripts/recordmcount.pl between commits
> e2d753fac5b3954a3b6001f98479f0435fe7c868 ("tracing: Correct the check for
> number of arguments in recordmcount.pl") and
> 7d241ff0567b9503d79ee775c40927d09b509f83 ("microblaze: ftrace: Add
> dynamic trace support") from Linus' tree and commits
> 84bc2d35f211a83e806711c94f78a227c4810848 ("MIPS: Tracing: Add an endian
> argument to scripts/recordmcount.pl") and
> b2b11a5cb24b8f234bc4746dc40722b01fa45a43 ("MIPS: Tracing: Add dynamic
> function tracer support") from the mips tree.
> 
> These conflicts are now between Linus' tree and the mips tree so, Ralf,
> you should be able to fix them up by merging with Linus' tree.
> 
> I have fixed them up (see below) (for the first pair of commits above, I
> used the mips tree version) and can carry the fix for a while.

Yes, because I sent pull request to Linus and he added Microblaze 
patches to his tree. Sorry for this additional work but you had chance 
to pull your tree first.

Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
