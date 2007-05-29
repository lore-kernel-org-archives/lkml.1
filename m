Return-Path: <linux-kernel-owner+w=401wt.eu-S1759696AbXE2Qq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696AbXE2Qq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbXE2QqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:46:22 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751828AbXE2QqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:46:22 -0400
Date: Tue, 29 May 2007 09:46:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression: USB is nfg after suspend/resume(RAM) cycle on Intel
 chipset
In-Reply-To: <465C566E.4030009@rtr.ca>
Message-ID: <alpine.LFD.0.98.0705290945520.26602@woody.linux-foundation.org>
References: <465C566E.4030009@rtr.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 May 2007, Mark Lord wrote:
> 
> There are a zillion USB patches in 2.6.22-rc*.
> Greg: got any good suggestions on which one to revert first?

Any chance of bisecting it?

		Linus
