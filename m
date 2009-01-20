Return-Path: <linux-kernel-owner+w=401wt.eu-S1762111AbZATB33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762111AbZATB33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbZATB3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:29:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50920
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756098AbZATB3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:29:15 -0500
Date: Mon, 19 Jan 2009 17:29:17 -0800 (PST)
Message-Id: <20090119.172917.38569263.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: slavon@bigtelecom.ru, a.p.zijlstra@chello.nl, denys@visp.net.lb,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: [PATCH] Re: deadlocks if use htb
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090119075733.GA4788@ff.dom.local>
References: <20090119065715.GA4197@ff.dom.local>
	<49742EE5.9090502@bigtelecom.ru>
	<20090119075733.GA4788@ff.dom.local>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Mon, 19 Jan 2009 07:57:33 +0000

> On Mon, Jan 19, 2009 at 10:42:29AM +0300, Badalian Vyacheslav wrote:
> > Tested 2 days (weekend is stress days for this bug, because its have
> > many traffic) at 3 servers. Fly normal. For completed test need up to 7
> > days, but i think (imho) this patch not break any functional and may
> > safely added to stable. 100% help for me patch # 2+3.
> 
> Thank you very much, Slavon! (2+3 are of course better tested, but
> I hope this #4 is more appropriate for -stable.)

I've queued this up, thanks everyone.
