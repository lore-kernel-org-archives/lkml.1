Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbXLEFg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbXLEFg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 00:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbXLEFgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 00:36:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbXLEFgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 00:36:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Shi Weihua <shiwh@cn.fujitsu.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] signal(i386): alternative signal stack wraparound
 occurs
In-Reply-To: Shi Weihua's message of  Wednesday, 5 December 2007 13:22:39 +0800 <4756359F.5000008@cn.fujitsu.com>
References: <474CF7D5.6010702@cn.fujitsu.com>
	<474D05AE.60905@cn.fujitsu.com>
	<20071204130218.GE31590@elte.hu>
	<20071204215251.60C6326F8D9@magilla.localdomain>
	<4756359F.5000008@cn.fujitsu.com>
X-Shopping-List: (1) Sullen Icelandic snowbulb persecuters
   (2) Fuel-injected breeze wavechords
   (3) Civil lunchbox suction
Message-Id: <20071205053647.DFD0826F8D9@magilla.localdomain>
Date: Tue,  4 Dec 2007 21:36:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am sorry, i don't understand how this is related to the semantics of
> e.g. longjmp.  But, i am sure my patch solves all overflows. Ingo's patch
> can't catch the overflow which is caught by "int i[1000];" in the handler
> function.

Please read the long explanation I wrote, which Ingo forwarded.

Thanks,
Roland
