Return-Path: <linux-kernel-owner+w=401wt.eu-S1763027AbXHaF3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763027AbXHaF3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 01:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759365AbXHaF3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 01:29:13 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:57047 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759096AbXHaF3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 01:29:11 -0400
Message-ID: <46D7A723.9080002@suse.de>
Date: Fri, 31 Aug 2007 09:29:07 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Daniel Ritz <daniel.ritz-ml@swissonline.ch>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ACPI: EC: Check if boot_ec was really found in DSDT
References: <200708290129.57243.daniel.ritz-ml@swissonline.ch> <20070829232150.GA17467@dreamland.darkstar.lan> <200708301907.56561.daniel.ritz-ml@swissonline.ch> <alpine.LFD.0.999.0708301020410.25853@woody.linux-foundation.org> <46D7A196.7070309@suse.de> <alpine.LFD.0.999.0708302220490.25853@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708302220490.25853@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Fri, 31 Aug 2007, Alexey Starikovskiy wrote:
>   
>> Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
>>     
>
> This was totally whitespace-damaged. You have some broken email client 
> that turns <tab>s into four spaces.
>
> May I suggest rethinking the use of Thunderbird (aka "mangles things 
> ridiculously")?
>
> Anyway, I fixed it up and applied it.
>
> 		Linus
>   
Thanks, what client do you use/recommend?

Alex.
