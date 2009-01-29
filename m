Return-Path: <linux-kernel-owner+w=401wt.eu-S1758372AbZA2Egc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372AbZA2Egc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZA2EgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:36:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59526
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751049AbZA2EgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:36:22 -0500
Date: Wed, 28 Jan 2009 20:36:19 -0800 (PST)
Message-Id: <20090128.203619.31343560.davem@davemloft.net>
To: johnstul@us.ibm.com
Cc: linux-kernel@vger.kernel.org, rmk+lkml@arm.linux.org.uk,
       cooloney@kernel.org, starvik@axis.com, takata@linux-m32r.org,
       geert@linux-m68k.org, zippel@linux-m68k.org, lethal@linux-sh.org,
       magnus.damm@gmail.com, wli@holomorphy.com, chris@zankel.net,
       tglx@linutronix.de
Subject: Re: [RFC][PATCH 8/10] Convert sparc to use arch_getoffset()
 infrastructure.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1233202241.6895.45.camel@localhost.localdomain>
References: <1233202175.6895.40.camel@localhost.localdomain>
	<1233202206.6895.43.camel@localhost.localdomain>
	<1233202241.6895.45.camel@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: john stultz <johnstul@us.ibm.com>
Date: Wed, 28 Jan 2009 20:10:41 -0800

> This patch converts sparc to use GENERIC_TIME via the arch_getoffset()
> infrastructure 
> 
> I do not have cross compilers for these architectures, and in some cases
> the architectures can be compiles both with and without clocksources. So
> I've taken my best swing at converting this, but I'm not confident I got
> it right. Any assistance from arch maintainers or testers would be
> great.
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>

Acked-by: David S. Miller <davem@davemloft.net>
