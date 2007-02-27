Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbXB0PpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbXB0PpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 10:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbXB0PpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 10:45:23 -0500
Received: from smtp.osdl.org ([65.172.181.24]:37817 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbXB0PpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 10:45:23 -0500
Date: Tue, 27 Feb 2007 07:42:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: regression: forcedeth.c hang
In-Reply-To: <20070227112521.GA9440@elte.hu>
Message-ID: <Pine.LNX.4.64.0702270741300.12485@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
 <20070225175247.GB12392@stusta.de> <20070227083918.GC30376@elte.hu>
 <20070227090106.GA2749@elte.hu> <20070227093817.GA5007@elte.hu>
 <20070227112521.GA9440@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Feb 2007, Ingo Molnar wrote:
> 
> update: Jeff sent me 3 pending forcedeth.c fixes, and they indeed fix 
> the regression. The one that fixed it is:

Ok, that was included in the bunch I just pulled and pushed out, so 
hopefully this one is resolved. Pls verify.

		Linus
