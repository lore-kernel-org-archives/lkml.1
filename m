Return-Path: <linux-kernel-owner+w=401wt.eu-S933569AbXCFBdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569AbXCFBdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 20:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933784AbXCFBdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 20:33:31 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45541 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933569AbXCFBda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 20:33:30 -0500
Date: Mon, 5 Mar 2007 17:31:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Ingo Molnar <mingo@elte.hu>,
       Soeren Sonnenburg <kernel@nn7.de>, Len Brown <lenb@kernel.org>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
In-Reply-To: <1173142948.24738.257.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703051730230.3998@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> 
 <20070305015040.GJ3441@stusta.de>  <1173138193.24738.236.camel@localhost.localdomain>
  <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0703051626490.3998@woody.linux-foundation.org>
 <1173142948.24738.257.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Mar 2007, Thomas Gleixner wrote:
> 
> Sure. I fought it all day. Can you please test the patch I sent a couple
> of minutes ago ? Would be great to have your feedback tomorrow morning. 

Compiling right now - delayed because I just had to pick up one of the 
kids from gymnastics.

> We need to fix that ACPI problem (acpi_processor_start is not called
> when CPU#1 is resumed) as well. I look into this tomorrow unless Len
> beats me.

Ok, thanks.

		Linus
