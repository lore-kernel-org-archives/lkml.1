Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbYAQV6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbYAQV6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbYAQV6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:58:41 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:41856 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbYAQV6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:58:40 -0500
Message-ID: <478FCF99.4060505@davidnewall.com>
Date: Fri, 18 Jan 2008 08:28:49 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
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
References: <9BdU5-1YW-9@gated-at.bofh.it>	<200801081810.58904.linux@rainbow-software.org>	<4783B1B2.6070005@reed.com>	<200801081838.16241.linux@rainbow-software.org>	<4783C4A6.9060402@reed.com>	<20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>	<4783CBD9.7020709@reed.com>	<1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>	<47845972.9090803@zytor.com>	<1199915614.7369.367.camel@bodhitayantram.eng.vmware.com>	<47854916.4080703@reed.com>	<1200015388.6192.22.camel@bodhitayantram.eng.vmware.com>	<4786DD05.20804@keyaccess.nl>	<47877ECD.9060408@reed.com>	<1200347847.2647.97.camel@shinybook.infradead.org>	<478BE08B.3090306@reed.com>	<478E1668.9040404@davidnewall.com>	<20080116145515.6d84dc7b@lxorguk.ukuu.org.uk>	<478E57C8.2080403@davidnewall.com>	<20080116200829.26040351@lxorguk.ukuu.org.uk>	<478EF4C9.8030406@davidnewall.com> <20080117120227.3d09baf5@lxorguk.ukuu.org.uk> <478F59CC.8050907@davidnewall.com> <478F5E47.6000204@keyaccess.nl>
In-Reply-To: <478F5E47.6000204@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> Over the course of a 100 messages or so in this thread it's been
> determined that the best course of action is to keep the out for ISA
> and replace it with udelay() for chipset logic. Now go away. 

Rather than this incredible rudeness, why don't you direct your energy
towards convincing Alan of this.  He's the hold-out.
