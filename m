Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbYL1E0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbYL1E0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 23:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbYL1EZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 23:25:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50084
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754007AbYL1EZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 23:25:49 -0500
Date: Sat, 27 Dec 2008 20:25:52 -0800 (PST)
Message-Id: <20081227.202552.27482357.davem@davemloft.net>
To: sam@ravnborg.org
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org, mingo@elte.hu,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, kenchen@google.com,
       paulus@samba.org, tglx@linutronix.de, hpa@zytor.com,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] sparc64: use unsigned long long for u64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081227094955.GA1355@uranus.ravnborg.org>
References: <20081227092404.GA10375@uranus.ravnborg.org>
	<20081227.013712.63335017.davem@davemloft.net>
	<20081227094955.GA1355@uranus.ravnborg.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 27 Dec 2008 10:49:55 +0100

> I have ordered a used Sun Blade 100(*) that should show up
> before new eve.
> So when I have it and it is up and running I will redo this
> patch set. That will likely take a few weeks though.

Another option, of course, is to use 64-bit cross tools
on an x86_64 system if you have access to one of those.

> (*) Any distribution recommendations? I will only use it for
>     sparc kernel development so nothing fancy...

Debian testing works fine, and that's what I'm typing this
on.
