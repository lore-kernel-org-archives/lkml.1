Return-Path: <linux-kernel-owner+w=401wt.eu-S933003AbXHaHH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbXHaHH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 03:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbXHaHHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 03:07:18 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40495 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576AbXHaHHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 03:07:17 -0400
Message-ID: <46D7BE1E.9060009@garzik.org>
Date: Fri, 31 Aug 2007 03:07:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Daniel Ritz <daniel.ritz-ml@swissonline.ch>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] ACPI: EC: Check if boot_ec was really found in DSDT
References: <200708290129.57243.daniel.ritz-ml@swissonline.ch>	<20070829232150.GA17467@dreamland.darkstar.lan>	<200708301907.56561.daniel.ritz-ml@swissonline.ch>	<alpine.LFD.0.999.0708301020410.25853@woody.linux-foundation.org>	<46D7A196.7070309@suse.de>	<alpine.LFD.0.999.0708302220490.25853@woody.linux-foundation.org>	<46D7A723.9080002@suse.de> <20070830223418.70958a58.akpm@linux-foundation.org>
In-Reply-To: <20070830223418.70958a58.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> I use sylpheed.  thunderbird can be used, but one needs to follow
> the steps in http://mbligh.org/linuxdocs/Email/Clients/Thunderbird
> to get it out of i-know-better mode.


Can we get something like this into the kernel tree, please?

Documentation/email-clients.txt would go a long way towards making our 
collective lives more simple.

	Jeff


