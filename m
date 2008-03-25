Return-Path: <linux-kernel-owner+w=401wt.eu-S1762052AbYCYXLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762052AbYCYXLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758189AbYCYXLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:11:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33182
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756775AbYCYXLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:11:42 -0400
Date: Tue, 25 Mar 2008 16:11:42 -0700 (PDT)
Message-Id: <20080325.161142.65862968.davem@davemloft.net>
To: mingo@elte.hu
Cc: joern@logfs.org, jirislaby@gmail.com, viro@ZenIV.linux.org.uk,
       joe@perches.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
 - formatting only
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080325134556.GA10424@elte.hu>
References: <20080325131258.GC11359@logfs.org>
	<20080325133810.GA10044@elte.hu>
	<20080325134556.GA10424@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 25 Mar 2008 14:45:56 +0100

> and let me give an example with the your very own code that you wrote 
> and maintain, drivers/mtd/devices/block2mtd.c:
> 
>                                     errors   lines of code   errors/KLOC
> drivers/mtd/devices/block2mtd.c         10             490          20.4

Ingo, this is devolving into a "code I maintain is great, code you
maintain sucks, checkpatch says so" kind of discussion, please stop.

You're not making any friends by making your arguments this way.
