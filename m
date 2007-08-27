Return-Path: <linux-kernel-owner+w=401wt.eu-S1762223AbXH0QTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762223AbXH0QTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760423AbXH0QJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:09:18 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53234 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760154AbXH0QJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:09:16 -0400
Date: Mon, 27 Aug 2007 18:09:16 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>,
       =?utf-8?B?QmrDtnJu?= Steinbrink <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: Who wants to maintain KR list for stable releases? (was Re:
	nmi_watchdog=2 regression in 2.6.21)
Message-ID: <20070827160916.GF4121@stusta.de>
References: <1186531609.22044.50.camel@imap.mvista.com> <20070808142059.GF30805@atjola.homenet> <1187628296.7732.14.camel@imap.mvista.com> <46CDE94A.7000600@googlemail.com> <1187904169.2435.83.camel@dhcp193.mvista.com> <46D21E8E.4000003@googlemail.com> <20070827005131.b93f5935.akpm@linux-foundation.org> <46D29C3D.5070801@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46D29C3D.5070801@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 05:41:17AM -0400, Jeff Garzik wrote:
> Andrew Morton wrote:
>> What I'm concerned about is that regressions which we didn't fix are just
>> getting lost.  Is anyone taking care to ensure that they are getting
>> transitioned into bugzilla for tracking?
>
> Maybe this was a dumb assumption on my part, but I thought regressions were 
> getting rolled over into the next release's list, if they are not solved?

Judging from the regression lists and the regression reports we get 
post-release both on lkml and in the kernel Bugzilla we have much more 
than 100 unfixed regressions since 2.6.20 (plus regressions from older 
kernels...).

Tracking that many regressions is one problem (although getting all bug 
reports in Bugzilla would make this quite easy), but the bigger problem 
is how to get them debugged and resolved.

> 	Jeff

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

