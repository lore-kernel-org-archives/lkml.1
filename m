Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYBELZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYBELZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 06:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYBELZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 06:25:37 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:45814 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbYBELZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 06:25:36 -0500
Date: Tue, 5 Feb 2008 13:25:40 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg Ungerer <gerg@snapgear.com>, Miles Bader <miles@gnu.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] remove the v850 port
Message-ID: <20080205112540.GA21042@cs181133002.pp.htv.fi>
References: <20080120192356.GI8669@does.not.exist> <4793E42B.7080400@snapgear.com> <20080128221320.GI8767@does.not.exist> <20080201151427.GA32085@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080201151427.GA32085@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 04:14:27PM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > Trying to compile the v850 port brings you many compile errors, one of 
> > them exists since at least kernel 2.6.19.
> > 
> > There also seems to be noone willing to bring this port back into a 
> > usable state.
> > 
> > This patch therefore removes the v850 port.
> 
> start by putting the intention of removal into:
> 
>    Documentation/feature-removal-schedule.txt
> 
> we can remove it after that. Same for most of your other removal 
> patches.

Why?

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

