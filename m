Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbXE2Wo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbXE2Wo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbXE2WoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:44:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42819
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751949AbXE2WoP (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:44:15 -0400
Date: Tue, 29 May 2007 15:44:28 -0700 (PDT)
Message-Id: <20070529.154428.11609556.davem@davemloft.net>
To: tglx@linutronix.de
Cc: iank@bredband.net, Linux-kernel@vger.kernel.org, mingo@elte.hu,
       arjan@infradead.org
Subject: Re: [BUG] Something goes wrong with timer statistics.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1180478532.20546.41.camel@chaos>
References: <1180474738.22497.25.camel@pi.pomac.com>
	<20070529.153723.108751260.davem@davemloft.net>
	<1180478532.20546.41.camel@chaos>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 30 May 2007 00:42:12 +0200

> On Tue, 2007-05-29 at 15:37 -0700, David Miller wrote:
> > I see this same exact problem on sparc64.
> 
> 100% reproducible ?

I think so, I'll try to find time to tinker with it a bit
more.
