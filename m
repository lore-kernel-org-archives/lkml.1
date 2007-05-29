Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbXE2WhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbXE2WhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbXE2WhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:37:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33622
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbXE2WhL (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:37:11 -0400
Date: Tue, 29 May 2007 15:37:23 -0700 (PDT)
Message-Id: <20070529.153723.108751260.davem@davemloft.net>
To: iank@bredband.net
Cc: Linux-kernel@vger.kernel.org
Subject: Re: [BUG] Something goes wrong with timer statistics.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1180474738.22497.25.camel@pi.pomac.com>
References: <1180474738.22497.25.camel@pi.pomac.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Kumlien <iank@bredband.net>
Date: Tue, 29 May 2007 23:38:48 +0200

> As the daystar sets, i try to play some with my new would be
> firewall/server, but since this will be running for quite some time i
> have been experimenting with powertop to find out what i can do to limit
> it's power usage.
> 
> But, if i run powertop for too long or a few times to many... this
> happens:
> http://pomac.netswarm.net/pics/kernel_panic.jpg
> 
> If i don't run powertop, it is rock solid... Compiling for hours,
> running memtest for hours etc etc... 

I see this same exact problem on sparc64.
