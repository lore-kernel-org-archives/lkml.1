Return-Path: <linux-kernel-owner+w=401wt.eu-S1762012AbXGCVdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762012AbXGCVdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757165AbXGCVdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:33:31 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33569 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbXGCVda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:33:30 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jul 2007 17:33:30 EDT
Date: Tue, 03 Jul 2007 14:36:09 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 2/2] net: make net and forcedeth to use kmalloc_node
In-reply-to: <20070703115840.e05a0f47.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <468AC149.4020205@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=US-ASCII
Content-transfer-encoding: 7BIT
References: <200706291330.37070.yinghai.lu@sun.com>
 <20070703115840.e05a0f47.akpm@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 29 Jun 2007 13:30:36 -0700
> Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
>> [PATCH 2/2] net: make net and forcedeth to use kmalloc_node
> 
> Please copy netdev@vger.kernel.org on net patches.
> 
> It might help to edit code in an 80-col xterm.
> 
> Please run scritps/checkpatch.pl across all your diffs.  Its suggestions
> are by no means compulsory, but they do provide things for you to check up
> and and have a think about, thanks.

I see. later.

Thanks

Yinghai Lu
