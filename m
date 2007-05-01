Return-Path: <linux-kernel-owner+w=401wt.eu-S1946184AbXEAALp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946184AbXEAALp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 20:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946190AbXEAALo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 20:11:44 -0400
Received: from rtr.ca ([64.26.128.89]:4052 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946184AbXEAALn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 20:11:43 -0400
Message-ID: <463685BD.8010604@rtr.ca>
Date: Mon, 30 Apr 2007 20:11:41 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Daniel Walker <dwalker@mvista.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both of CONFIG_NO_HZ,
 CONFIG_HIGH_RES_TIMERS
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>	 <463653A3.5040606@rtr.ca> <46367D7E.6060502@rtr.ca>	 <1177976798.12796.286.camel@imap.mvista.com> <463683A6.4010505@rtr.ca> <6bffcb0e0704301707w7287f1bdk32be8bc8ce7cda80@mail.gmail.com>
In-Reply-To: <6bffcb0e0704301707w7287f1bdk32be8bc8ce7cda80@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> 
> Please read chapter 3 {serial,net}console
> http://www.stardust.webpages.pl/files/handbook/handbook-en.pdf

No thanks.

No serial, and netconsole doesn't work during early boot when it locks up.
Besides, we already know as much as the existing messages show.

-ml
