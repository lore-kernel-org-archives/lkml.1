Return-Path: <linux-kernel-owner+w=401wt.eu-S1031390AbXDZTNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031390AbXDZTNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031458AbXDZTNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:13:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60706 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031390AbXDZTNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:13:24 -0400
Message-ID: <4630F9CB.10600@garzik.org>
Date: Thu, 26 Apr 2007 15:13:15 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <4630E00B.3090502@tmr.com> <4630E9C8.5060000@garzik.org> <20070426183602.GT3468@stusta.de> <20070426185851.GA7352@electric-eye.fr.zoreil.com>
In-Reply-To: <20070426185851.GA7352@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:
> Pointer for the rtl8139 regression please ?

I'm guessing it's this one:

> 	Subject    : boot failure: rtl8139: exception in interrupt routine
> 	References : http://lkml.org/lkml/2007/3/31/160
> 	Submitter  : Stephen Clark <Stephen.Clark@seclark.us>
> 	Status     : unknown


The poster says rtl8139, but doesn't provide more info.  His lspci says 
"RTL8169SC", which sounds more like r8169 to me.

	Jeff


