Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbZKWNn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbZKWNn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 08:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbZKWNn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 08:43:28 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55285 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZKWNn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 08:43:27 -0500
Message-ID: <4B0A917F.8060000@petalogix.com>
Date: Mon, 23 Nov 2009 14:43:27 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Wu Zhangjin <wuzhangjin@gmail.com>,
       linux-mips@linux-mips.org
Subject: Re: linux-next: Tree for November 23
References: <20091123185232.1423c56b.sfr@canb.auug.org.au> <4B0A8841.8090905@petalogix.com> <20091123131932.GA28687@linux-mips.org>
In-Reply-To: <20091123131932.GA28687@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle wrote:
> On Mon, Nov 23, 2009 at 02:04:01PM +0100, Michal Simek wrote:
> 
>>> The microblaze tree still has a build failure for which I reverted a
>>> commit.
>>>
>>> The mips tree gained a conflict against the microblaze tree.
>> It is problem which is caused one my ftrace patch. MIPS ftrace  
>> implementation was first that's why I should solve it. It is easy to fix.
>> I just need to know where mips/mips-for-linux-next branch is.
> 
> Gitweb:  http://www.linux-mips.org/git?p=upstream-sfr.git;a=summary
> Git:     git://www.linux-mips.org/pub/scm/upstream-sfr.git

Thanks,
Michal

> 
>   Ralf 


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
