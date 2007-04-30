Return-Path: <linux-kernel-owner+w=401wt.eu-S1946490AbXD3UTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946490AbXD3UTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 16:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946755AbXD3UTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 16:19:43 -0400
Received: from rtr.ca ([64.26.128.89]:1314 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946490AbXD3UTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 16:19:42 -0400
Message-ID: <46364F5A.2030208@rtr.ca>
Date: Mon, 30 Apr 2007 16:19:38 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Cc: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both of CONFIG_NO_HZ,
 CONFIG_HIGH_RES_TIMERS
References: <46364EBC.5050804@rtr.ca>
In-Reply-To: <46364EBC.5050804@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> I have a new notebook (Dell Inspiron 9400) with Core2-Duo T7400 @ 2.1Ghz.
> When either/both of CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS is used,
> the 2.6.21 kernel hangs on startup just after printing one/both of these:
..

That's a hard hang, by the way.  No magic sysrq key or anything.
