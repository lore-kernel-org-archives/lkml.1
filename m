Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609AbYHWKXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbYHWKXY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 06:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYHWKXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 06:23:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48566 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbYHWKXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 06:23:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Matt Parnell" <mparnell@gmail.com>
Subject: Re: [Bug #11279] 2.6.27-rc0 Power Bugs with HP/Compaq Laptops
Date: Sat, 23 Aug 2008 12:26:38 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <200808230019.09040.rjw@sisk.pl> <680ad8bc0808230032g458319b6nbcaddd24ad84f7a4@mail.gmail.com>
In-Reply-To: <680ad8bc0808230032g458319b6nbcaddd24ad84f7a4@mail.gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808231226.39080.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 23 of August 2008, you wrote:
> Arrgh...I spoke too soon. It'll boot if I disable hrtimers, but I also
> have to make it use jiffies as the clocksource...so I guess we're back
> to square one. If i have hrtimers enabled, with or without
> clocksource=jiffies, I end up getting segfaults...so, I'm pretty much
> not sure what to do at this point, but relay this message to the pros.

Well, thanks for the update again.

I've added some CCs to the message, perhaps someone will have an idea what to
do next.

Thanks,
Rafafel
