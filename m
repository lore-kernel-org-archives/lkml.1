Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbZEIPn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbZEIPn1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 11:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbZEIPnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 11:43:16 -0400
Received: from gw.goop.org ([64.81.55.164]:56763 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbZEIPnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 11:43:15 -0400
Message-ID: <4A05A493.7050107@goop.org>
Date: Sat, 09 May 2009 08:43:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen: dom0 support for PCI access
References: <1241732737-7669-1-git-send-email-jeremy@goop.org> <20090508111024.GD11596@elte.hu> <20090508124436.GT8112@parisc-linux.org>
In-Reply-To: <20090508124436.GT8112@parisc-linux.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Fri, May 08, 2009 at 01:10:24PM +0200, Ingo Molnar wrote:
>   
>> ( Cc:-ed PCI folks. Original thread with patches is on lkml. There's
>>   a few details that affect non-Xen PCI code too - and it would be
>>   nice to see feedback on this general method as well, from the PCI 
>>   experts . )
>>     
>
> I read over the top seven commits here:
> http://git.kernel.org/?p=linux/kernel/git/jeremy/xen.git;a=shortlog;h=xen-tip/dom0/pci
> and they all seem reasonable to me as far as they affect other code.
> I'm assuming that Xen people know what they're doing with respect to
> the Xen-only code ;-)
>   

Thanks.  Can I put your acked-by on those 7 changes (after fixing the 
__init thing Yinghai mentioned)?

    J
