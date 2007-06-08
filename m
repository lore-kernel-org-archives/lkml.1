Return-Path: <linux-kernel-owner+w=401wt.eu-S1030864AbXFHQ5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030864AbXFHQ5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969363AbXFHQ47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:56:59 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:48495 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S969238AbXFHQ46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:56:58 -0400
Subject: Re: [usb-storage] 2.6.22-rc4-mm2 - usb-storage
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0706081252140.3696-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0706081252140.3696-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 18:55:55 +0200
Message-Id: <1181321755.5728.1.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 12:54 -0400, Alan Stern wrote:
> On Fri, 8 Jun 2007, Peter Zijlstra wrote:
> 
> > > Okay, this is a separate problem.  To help diagnose it, please turn on 
> > > CONFIG_USB_DEBUG and CONFIG_USB_STORAGE_DEBUG and then post the 
> > > resulting dmesg log.
> > 
> > Here goes:
> > 
> >  http://programming.kicks-ass.net/misc/dmesg
> 
> Okay, it's not a separate problem.  You didn't revert the patch I 
> mentioned earlier.  It's generating those WARNINGs and causing 
> usb-storage to fail.

Ah, ok, my bad, I had understood the warning were merely cosmetic
damage.

Thanks.

