Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbXE0UCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbXE0UCT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 16:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbXE0UCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 16:02:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:54606 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbXE0UCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 16:02:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=W5cv+1mdIXkm6mVVCjkIvBHXQUD67dViVwvX9rMFInpj2Da6VOzuv5aSTvUBvkUxPi5JaU00EEv/E/zdjanqk8vl8PXTudIFZStj5JESQq1rFUgJR1k217BO1aaGs64nK592ZcVXt4Cv+po32iV92NIZf5kHqG9BqtiOkccD5Mw=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: "Uwe Bugla" <uwe.bugla@gmx.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sun, 27 May 2007 22:02:04 +0200
User-Agent: KMail/1.8.2
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070524195616.234280@gmx.net>
In-Reply-To: <20070524195616.234280@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705272202.04764.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 May 2007 21:56, Uwe Bugla wrote:
> Please note:
> 
> 1. IRQ 255 looks very idiotic, doesn't it? It does not exist at all, does it?
> 
> Questions:
> 
> 1. What is the technical need / progress of module ssb please?
> 
> 2. If Andrew Morton's guidelines clearly say: "Do test your patches on three different machines" and this guideline seems to be strictly ignored by some sparetime hackers:
> 
> What is the master plan then to avoid the fact that such a crap is being sent in to Andrew?
> 
> Yours sincerely
> 
> Uwe
> 
> P. S.: There is an important saying going like this:
> 
> Too many cooks do mess up the pap.
> 
> Regarding the patch in mm-tree I can see SIX (!) Copyright owners.
> The last one of them (i. e. the one of 2007) obviuosly does not seem to understand what he is doing (see that nonsense interrupt please, just incredible!) :(
> 
> In so far I would deeply appreciate Andrew Morton to throw that b44.c patch into the trashbox as soon as possible :)

Uwe, you are an arrogant idiot and I think it's best
for everybody to just ignore all your mails, regardless
of their technical merits.

Even if your mail reports a real bug, added shitload of insults
to developers far outweights any possible useful info.

Developers can save a lot of time and nerver by just waiting for
someone else to hit the same bug, if it exists, and then debug it
as usual.
--
vda
