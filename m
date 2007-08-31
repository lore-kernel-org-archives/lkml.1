Return-Path: <linux-kernel-owner+w=401wt.eu-S932367AbXHaFXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbXHaFXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 01:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbXHaFXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 01:23:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36568 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758017AbXHaFXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 01:23:08 -0400
Date: Thu, 30 Aug 2007 22:22:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
cc: Daniel Ritz <daniel.ritz-ml@swissonline.ch>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ACPI: EC: Check if boot_ec was really found in DSDT
In-Reply-To: <46D7A196.7070309@suse.de>
Message-ID: <alpine.LFD.0.999.0708302220490.25853@woody.linux-foundation.org>
References: <200708290129.57243.daniel.ritz-ml@swissonline.ch>
 <20070829232150.GA17467@dreamland.darkstar.lan> <200708301907.56561.daniel.ritz-ml@swissonline.ch>
 <alpine.LFD.0.999.0708301020410.25853@woody.linux-foundation.org>
 <46D7A196.7070309@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Aug 2007, Alexey Starikovskiy wrote:
> 
> Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>

This was totally whitespace-damaged. You have some broken email client 
that turns <tab>s into four spaces.

May I suggest rethinking the use of Thunderbird (aka "mangles things 
ridiculously")?

Anyway, I fixed it up and applied it.

		Linus
