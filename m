Return-Path: <linux-kernel-owner+w=401wt.eu-S1031025AbXEANcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031025AbXEANcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031224AbXEANcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:32:03 -0400
Received: from www.osadl.org ([213.239.205.134]:35527 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031025AbXEANcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:32:01 -0400
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both
	of	CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Mark Lord <lkml@rtr.ca>
Cc: Daniel Walker <dwalker@mvista.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <463683A6.4010505@rtr.ca>
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>
	 <463653A3.5040606@rtr.ca>  <46367D7E.6060502@rtr.ca>
	 <1177976798.12796.286.camel@imap.mvista.com>  <463683A6.4010505@rtr.ca>
Content-Type: text/plain
Date: Tue, 01 May 2007 15:34:18 +0200
Message-Id: <1178026458.5791.305.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Mon, 2007-04-30 at 20:02 -0400, Mark Lord wrote:
> When it does boot with the modified .config file,
> the log looks like the one attached to this email.

Can you please send me the output of /proc/timer_list ?

	tglx


