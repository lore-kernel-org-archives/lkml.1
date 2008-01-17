Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbYAQN7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbYAQN7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 08:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbYAQN7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 08:59:44 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:35488 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbYAQN7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 08:59:43 -0500
Message-ID: <478F5E47.6000204@keyaccess.nl>
Date: Thu, 17 Jan 2008 14:55:19 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       David Woodhouse <dwmw2@infradead.org>, Zachary Amsden <zach@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christer Weinigel <christer@weinigel.se>,
       Ondrej Zary <linux@rainbow-software.org>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol <rol@witbe.net>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it>	<200801081810.58904.linux@rainbow-software.org>	<4783B1B2.6070005@reed.com>	<200801081838.16241.linux@rainbow-software.org>	<4783C4A6.9060402@reed.com>	<20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>	<4783CBD9.7020709@reed.com>	<1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>	<47845972.9090803@zytor.com>	<1199915614.7369.367.camel@bodhitayantram.eng.vmware.com>	<47854916.4080703@reed.com>	<1200015388.6192.22.camel@bodhitayantram.eng.vmware.com>	<4786DD05.20804@keyaccess.nl>	<47877ECD.9060408@reed.com>	<1200347847.2647.97.camel@shinybook.infradead.org>	<478BE08B.3090306@reed.com>	<478E1668.9040404@davidnewall.com>	<20080116145515.6d84dc7b@lxorguk.ukuu.org.uk>	<478E57C8.2080403@davidnewall.com>	<20080116200829.26040351@lxorguk.ukuu.org.uk>	<478EF4C9.8030406@davidnewall.com> <20080117120227.3d09baf5@lxorguk.ukuu.org.uk> <478F59CC.8050907@davidnewall.com>
In-Reply-To: <478F59CC.8050907@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-01-08 14:36, David Newall wrote:

> In the early days of clone PCs, as you know but perhaps many on this
> list might not

I'm so incredibly sick of this fucking thread. We've had enough legacy farts 
coming out of the woodwork advertising their own massive experience and 
cluelessness by now. Both hpa and alan are in this thread and everyone else 
can be ignored on the issue.

Over the course of a 100 messages or so in this thread it's been determined 
that the best course of action is to keep the out for ISA and replace it 
with udelay() for chipset logic. Now go away.

Rene.
