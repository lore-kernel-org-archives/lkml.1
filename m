Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbYEFG5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbYEFG5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 02:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYEFG4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 02:56:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56767
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752736AbYEFG4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 02:56:54 -0400
Date: Mon, 05 May 2008 23:56:54 -0700 (PDT)
Message-Id: <20080505.235654.232530105.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: mingo@elte.hu, andi@lisas.de, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mchehab@infradead.org
Subject: Re: Linux 2.6.26-rc1
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080506153552.805240f3.sfr@canb.auug.org.au>
References: <20080506095122.860796f6.sfr@canb.auug.org.au>
	<20080505.165501.62584352.davem@davemloft.net>
	<20080506153552.805240f3.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 6 May 2008 15:35:52 +1000

> On Mon, 05 May 2008 16:55:01 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
> > So what should I do now?
> > 
> > I have Ingo's IRDA PNP fixes in my net-2.6 tree and that's already
> > publicly visible, so I'd need to add revert changesets if people want
> > me to remove it.
> 
> Do nothing.  I was just making a point about patches getting lost/ignored.
> I have dropped my copies from linux-next today.
> 
> At least the fixes are now in a tree headed for Linus, soon.

Great, thanks.
