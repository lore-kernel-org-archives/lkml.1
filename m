Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbXF1O62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbXF1O62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 10:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755891AbXF1O6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 10:58:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:59027 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755418AbXF1O6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 10:58:20 -0400
X-Authenticated: #1474915
X-Provags-ID: V01U2FsdGVkX19IsCtPJtpIrKQGSQ7Pk3mmaZn+NMGDpcEL2UHvCQ
	YkPlylyeawExdl
Message-ID: <4683CC89.80406@gmx.de>
Date: Thu, 28 Jun 2007 16:58:17 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.22-rc6 spurious hangs
References: <4683BF16.40905@gmx.de> <20070628144741.GA437@tv-sign.ru>
In-Reply-To: <20070628144741.GA437@tv-sign.ru>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> As Ingo told me I run 'echo t > /proc/sysrq-trigger' this time. The
>> corresponding part of my syslogs is attached, as well as my kernel config.
> 
> Could you try the patch below? It dumps some info when flush_workqueue()
> hangs.

I'm compiling a patched kernel right now. As I wrote in my former mail the
whole thing not easy to trigger. So it can take some time to get the info.

Thanks so far,
Thomas

-- 
keep mailinglists in english, feel free to send PM in german
