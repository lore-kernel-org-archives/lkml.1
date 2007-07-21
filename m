Return-Path: <linux-kernel-owner+w=401wt.eu-S936933AbXGUBDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936933AbXGUBDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 21:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759645AbXGUBDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 21:03:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:5993 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbXGUBDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 21:03:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=WLYqRVzfeZHowGD8TvSpcMbMkuAL/alp5F6luCtWyM8wmuZnltwoDe+qUVyoanOX2SnhALYeR+t5FSYYaxEugQ0PDwaZloLJ6cl4Dm+xWik7HtDTjVfpLgP7CjbwJNrZLvDgLiOT9BlBABYVUrOTI7lH0mf8Lf1kgI5D6C+hE3A=
Message-ID: <46A15AE8.2060405@googlemail.com>
Date: Sat, 21 Jul 2007 03:01:28 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
References: <1184970779.4012.38.camel@chaos>
In-Reply-To: <1184970779.4012.38.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
>

[...]

> As usual, comments and suggestions are welcome!


Compiles and boots fine here ( on my Dell Precision WorkStation 530 MT ). And nothing broke so far.

I only got some Kconfig warnings[1] with my config[2] but that is.

( I don't know whatever this matter but it boots 7,52 seconds faster as current git head )

[1]http://194.231.229.228/linux-x86/warning
[2]http://194.231.229.228/linux-x86/config-x86

> 
> 	Thomas, Ingo
> 
> 


Regards,

Gabriel C
