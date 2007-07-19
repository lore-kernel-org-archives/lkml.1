Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbXGSGLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbXGSGLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 02:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbXGSGL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 02:11:29 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37913 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752946AbXGSGL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 02:11:28 -0400
Date: Thu, 19 Jul 2007 08:10:51 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kernel/sched.c: remove 2 unused exports
Message-ID: <20070719061051.GO3801@stusta.de>
References: <20070712235211.GS3492@stusta.de> <20070717192233.GG26283@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070717192233.GG26283@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 09:22:33PM +0200, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@stusta.de> wrote:
> 
> > This patch removes the following unused exports:
> > - EXPORT_SYMBOL(cond_resched_softirq);
> > - EXPORT_SYMBOL_GPL(__wake_up_sync);
> 
> these are there for API completeness - their counterparts are exported.

Why is something with a comment "For internal use only" part of the API?

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

