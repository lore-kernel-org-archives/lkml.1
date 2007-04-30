Return-Path: <linux-kernel-owner+w=401wt.eu-S1946118AbXD3XnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946118AbXD3XnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946122AbXD3XnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:43:11 -0400
Received: from www.osadl.org ([213.239.205.134]:48708 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946118AbXD3XnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:43:09 -0400
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both of
	CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <46367D7E.6060502@rtr.ca>
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>
	 <463653A3.5040606@rtr.ca>  <46367D7E.6060502@rtr.ca>
Content-Type: text/plain
Date: Tue, 01 May 2007 01:45:24 +0200
Message-Id: <1177976724.5791.263.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 19:36 -0400, Mark Lord wrote:

> Well, in case this helps.  If I take the exact same .config that fails,
> and add *only* this to it, it then boots just fine. 
> 
>    CONFIG_DETECT_SOFTLOCKUP=y

That's definitely helpful. Thanks for tracking it down. I look at it
tomorrow morning, when I'm awake.

> Thomas G., are you there??

Halfways. I'm on the way to my bed. :)

	tglx


