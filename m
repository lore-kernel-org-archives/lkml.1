Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbXEAAPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbXEAAPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 20:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946189AbXEAAOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 20:14:51 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:23529 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946187AbXEAAOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 20:14:49 -0400
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both of
	CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS
From: Daniel Walker <dwalker@mvista.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <463685BD.8010604@rtr.ca>
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>
	 <463653A3.5040606@rtr.ca> <46367D7E.6060502@rtr.ca>
	 <1177976798.12796.286.camel@imap.mvista.com> <463683A6.4010505@rtr.ca>
	 <6bffcb0e0704301707w7287f1bdk32be8bc8ce7cda80@mail.gmail.com>
	 <463685BD.8010604@rtr.ca>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 17:13:11 -0700
Message-Id: <1177978391.12796.301.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 20:11 -0400, Mark Lord wrote:
> Michal Piotrowski wrote:
> > 
> > Please read chapter 3 {serial,net}console
> > http://www.stardust.webpages.pl/files/handbook/handbook-en.pdf
> 
> No thanks.
> 
> No serial, and netconsole doesn't work during early boot when it locks up.
> Besides, we already know as much as the existing messages show.

Well I would be asking for it if I didn't need more information .. But
I'm interested in which clocksource is getting used, which is in the
boot log.

Daniel

