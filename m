Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbYI2T6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbYI2T6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 15:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbYI2T5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 15:57:54 -0400
Received: from colo.lackof.org ([198.49.126.79]:51889 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbYI2T5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 15:57:53 -0400
Date: Mon, 29 Sep 2008 13:57:41 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai Lu <yinghai@kernel.org>,
       Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 7/7] x86: print out irq nr for msi/ht -v2
Message-ID: <20080929195741.GB14409@colo.lackof.org>
References: <1222323223-23529-1-git-send-email-yhlu.kernel@gmail.com> <20080927185306.GA18619@elte.hu> <20080927190237.GD10186@localhost> <200809291005.04941.jbarnes@virtuousgeek.org> <20080929172928.GC7360@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929172928.GC7360@localhost>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 09:29:28PM +0400, Cyrill Gorcunov wrote:
> [Jesse Barnes - Mon, Sep 29, 2008 at 10:05:02AM -0700]
> | On Saturday, September 27, 2008 12:02 pm Cyrill Gorcunov wrote:
> | > [Ingo Molnar - Sat, Sep 27, 2008 at 08:53:06PM +0200]
> | >
> | > ...
> | >
> | > A bit offtopic...well...completely offtopic I would say :)
> | >
> | > Ingo maybe you have any PCI specs? I've asked several people
> | > for this. Peter adviced to ask HW vendors but I don't have
> | > friends who has access to a such docs. Evgeniy Polyakov
> | > promised to ask someone but I think there will not be success
> | > too :(. I'll ask Maciej too later since now he seems to be
> | > quite busy.
> | 
> | I think if you use google you can find the PCI spec in pdf form (search for 
> | pci pdf probably).

Not probably. You will find them that way.

It is illegal for anyone to redistribute PCISIG copyrighted documents.
That hasn't stopped it from happening. I've pointed this out in the past
(and got a polite "please don't point that out again publicly").
I'm glad Jesse did instead. :)

>   The MindShare books are also quite good, and cover PCI, 
> | PCI-X, and PCI Express in great detail (far more readable than the spec too).

+1

grant

> | 
> | -- 
> | Jesse Barnes, Intel Open Source Technology Center
> | 
> 
> Thanks for reply, Jesse! Of course I could use google. But actually
> the only think I found is version 2.2 (which is a bit old). Will take
> a look if I could buy this book (not sure if it may be done here). PCI
> membership is quite expencive for me that is why I was asking for this
> documents in private mails I sent before. I don't like to behave like
> that but just had to.
> 
> 		- Cyrill -
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
