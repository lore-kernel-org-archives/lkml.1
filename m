Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbYHVPWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbYHVPWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 11:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbYHVPV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 11:21:56 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51257 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947AbYHVPVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 11:21:55 -0400
Date: Fri, 22 Aug 2008 18:21:28 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <peterz@infradead.org>, Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: BUG in free_block (tainted)
Message-ID: <20080822152128.GD26762@cs181140183.pp.htv.fi>
References: <48A9E97B.6060601@simon.arlott.org.uk> <84144f020808181437n34f3a339j3392ccccfdfd60f9@mail.gmail.com> <48A9ECD2.8030801@simon.arlott.org.uk> <84144f020808181449i546349b9n248b5cf5399e4b0f@mail.gmail.com> <1219315723.8651.106.camel@twins> <1219315891.7813.388.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1219315891.7813.388.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 01:51:31PM +0300, Pekka Enberg wrote:
> 
> Oh, right. I guess I didn't even consider anyone would still be using
> the binary-only ATI crap now that we have proper open source drivers
> available.... ;-)

I never tried fglrx, but judging from my experiences with the onboard 
690G on the board I bought at the beginning of this year (with the two 
open source X11 drivers for it) the word "proper" is not appropriate 
when you want a working system.

And I'm not talking about stuff like Xv or even 3D - all I'm asking for 
is that DVI works flawlessly (and without sporadic GPU lookups).

Note that this is not meant against the developers of the open source 
drivers - that's simply one of the many areas where recent hardware
does not work flawlessly under Linux and developing drivers that work 
flawlessly takes some time.

> 		Pekka

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

