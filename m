Return-Path: <linux-kernel-owner+w=401wt.eu-S933537AbXEEUTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537AbXEEUTw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 16:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933482AbXEEUTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 16:19:52 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34402 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933460AbXEEUTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 16:19:51 -0400
Date: Sat, 5 May 2007 22:20:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Clifford Wolf <clifford@clifford.at>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Interrupt-Handling in User Space
Message-ID: <20070505202038.GA15168@uranus.ravnborg.org>
References: <20070505191707.GA9300@clifford.at> <1178394933.31213.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178394933.31213.22.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 09:55:33PM +0200, Thomas Gleixner wrote:
> On Sat, 2007-05-05 at 21:17 +0200, Clifford Wolf wrote:
> > afaics there is no mechanism in the official kernel tree to handle
> > interrupts in user space yet. I'd need that for an embedded project I'm
> > woking on atm and are so far not sure if I'm going to implement such a
> > generic interface or just write a simple driver that does the job for my
> > application. So I'd like to find out what the chances are that such a
> > feature will get accepted in the official kernel..
> 
> Please take a look at drivers/uio, which is currently in -mm and on the
> way to mainline.

UIO is featured in latest LWN kernel edition (subscribers only until Thursday).
That may help to get an overview.

http://lwn.net

	Sam
