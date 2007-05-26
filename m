Return-Path: <linux-kernel-owner+w=401wt.eu-S1761262AbXEZPhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761262AbXEZPhR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 11:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbXEZPhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 11:37:05 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:36204
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997AbXEZPhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 11:37:03 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Uwe Bugla <uwe.bugla@gmx.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 17:36:57 +0200
User-Agent: KMail/1.9.6
Cc: Maximilian Engelhardt <maxi@daemonizer.de>, linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20070524195616.234280@gmx.net> <200705260700.28777.mb@bu3sch.de> <200705261240.55153.uwe.bugla@gmx.de>
In-Reply-To: <200705261240.55153.uwe.bugla@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705261736.57362.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 May 2007 12:40:54 Uwe Bugla wrote:
> Yes! This sort of mistakes is completely impossible, as I use to work with 
> aliases rather than IP adresses. The machine I tried to ping (i. e. my 
> router) is called Jerry (as a reminiscence to Mr. "Captan Trips" from 
> Grateful Dead), and thus "ping jerry" returned the following:
> 
> "destination host unreachable"
> 
> Above that, I state for the second time now that I reverted your patches in 
> 2.6.22-rc2-mm1 with the effect that everything worked perfectly!
> Maxi said something at least similar. So how many proofs do you need, Mister 
> Buesch, to finally pick up patchworking now?? 

How about you stopping with your fucking aggressive wording??

> > Try it again, please.
> 
> NO!
> 
> > And please try with current wireless-dev tree.
> 
> A. I do not know where to download that wireless-dev tree.
> B. I do not know how to implement it into mm or mainline
> C. I have given enough sophisticated proof that your stuff in mm-tree is 
> highly incomplete / buggy.

Ok,

D. As you are not going to help me debugging, I am not going to fix.

> >
> > And I simply do not get it why you suddenly get a good IRQ number, like
> > everybody else does, without fixing The Bug (tm).
> 
> That consequence I already explained:
> But it's a pleasure for me to repeat it once more:
> 
> When you are saying Y to "EISA, VLB, PCI and on board controllers"
> 
> you simply do get not only completely different interrupts for the b4401 
> device, but you get also completely different module dependencies.

That is EXPECTED and I already explained that.
It is a feature. Not a bug.


-- 
Greetings Michael.
