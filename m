Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbXERU1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbXERU1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 16:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbXERU1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 16:27:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53326
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756173AbXERU1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 16:27:32 -0400
Date: Fri, 18 May 2007 13:27:34 -0700 (PDT)
Message-Id: <20070518.132734.34602464.davem@davemloft.net>
To: galak@kernel.crashing.org
Cc: tglx@linutronix.de, matt@genesi-usa.com, sshtylyov@ru.mvista.com,
       linuxppc-dev@ozlabs.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       r.schwebel@pengutronix.de
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <32E780BE-58B7-4303-AA49-1852C4C7EB50@kernel.crashing.org>
References: <464DB800.40702@genesi-usa.com>
	<1179499713.12981.75.camel@chaos>
	<32E780BE-58B7-4303-AA49-1852C4C7EB50@kernel.crashing.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@kernel.crashing.org>
Date: Fri, 18 May 2007 11:31:19 -0500

> I asked this earlier, but figured you might have a better insight.   
> Is their value in having 'drivers' for more than one clock source?   
> I'd say most (of not all) the PPC SoCs have timers on the system side  
> that we could provide drivers for, I'm just not sure if that does  
> anything for anyone.

I'm in a similar situation on sparc64, so I'm interested in
this as well :-)
