Return-Path: <linux-kernel-owner+w=401wt.eu-S1761458AbYCYXKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761458AbYCYXKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760795AbYCYXJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:09:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46156
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760777AbYCYXJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:09:17 -0400
Date: Tue, 25 Mar 2008 16:09:16 -0700 (PDT)
Message-Id: <20080325.160916.182495221.davem@davemloft.net>
To: mingo@elte.hu
Cc: jirislaby@gmail.com, viro@ZenIV.linux.org.uk, joe@perches.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
 - formatting only
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080325131708.GB9612@elte.hu>
References: <20080325084457.GA32103@elte.hu>
	<20080325.024204.175042056.davem@davemloft.net>
	<20080325131708.GB9612@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 25 Mar 2008 14:17:08 +0100

> There can be fluctuations and artifacts, and obviously this is just 
> another (arbitrary) static metric that has no forced relationship with 
> real code quality - but in my experience it's surprisingly close to 
> reality - closer than any other code metric i've seen.

And yet you used it to claim that the sparc64 port is an
unmaintainable pile of poo.

Thanks but no thanks, you just proved even more to me why
checkpatch is crap.
