Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbXJIFeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbXJIFeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 01:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbXJIFeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 01:34:10 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41364 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbXJIFeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 01:34:09 -0400
Date: Tue, 9 Oct 2007 07:34:08 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Vasily Averin <vvs@sw.ru>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>, devel@openvz.org
Subject: Re: irq0 stops working
In-Reply-To: <470B1119.8040207@sw.ru>
Message-ID: <Pine.LNX.4.64.0710090733410.14524@fbirervta.pbzchgretzou.qr>
References: <470B1119.8040207@sw.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 9 2007 09:26, Vasily Averin wrote:
>
>On one of our servers timer interrupts (i.e irq0) are stops working. As result
>any kernel timers do not triggers and tasks waiting some signals from timers
>hangs forever.

What kernel.. and tried CONFIG_NO_HZ=n?

