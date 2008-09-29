Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbYI2R3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbYI2R3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 13:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbYI2R3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 13:29:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:5567 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYI2R3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 13:29:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G8enGXkQzapVoyVq3UaSvu9tiKNrmb46hLUR05nh4cvqrxv6/n/vGcX3WNXm4BTJt7
         wtryvpyPbC2oL4KQyo0XIiyVjNKWhrjHDnt3oG6cMqn+lSbi6plMXLBLq1wDip+NL7wx
         xD9bMAyBZQcbWsJka5HQhgfQySqk0BBnQyAT0=
Date: Mon, 29 Sep 2008 21:29:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ingo Molnar <mingo@elte.hu>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 7/7] x86: print out irq nr for msi/ht -v2
Message-ID: <20080929172928.GC7360@localhost>
References: <1222323223-23529-1-git-send-email-yhlu.kernel@gmail.com> <20080927185306.GA18619@elte.hu> <20080927190237.GD10186@localhost> <200809291005.04941.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809291005.04941.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jesse Barnes - Mon, Sep 29, 2008 at 10:05:02AM -0700]
| On Saturday, September 27, 2008 12:02 pm Cyrill Gorcunov wrote:
| > [Ingo Molnar - Sat, Sep 27, 2008 at 08:53:06PM +0200]
| >
| > ...
| >
| > A bit offtopic...well...completely offtopic I would say :)
| >
| > Ingo maybe you have any PCI specs? I've asked several people
| > for this. Peter adviced to ask HW vendors but I don't have
| > friends who has access to a such docs. Evgeniy Polyakov
| > promised to ask someone but I think there will not be success
| > too :(. I'll ask Maciej too later since now he seems to be
| > quite busy.
| 
| I think if you use google you can find the PCI spec in pdf form (search for 
| pci pdf probably).  The MindShare books are also quite good, and cover PCI, 
| PCI-X, and PCI Express in great detail (far more readable than the spec too).
| 
| -- 
| Jesse Barnes, Intel Open Source Technology Center
| 

Thanks for reply, Jesse! Of course I could use google. But actually
the only think I found is version 2.2 (which is a bit old). Will take
a look if I could buy this book (not sure if it may be done here). PCI
membership is quite expencive for me that is why I was asking for this
documents in private mails I sent before. I don't like to behave like
that but just had to.

		- Cyrill -
