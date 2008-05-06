Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbYEFG1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbYEFG1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 02:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYEFG1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 02:27:25 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:35868 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbYEFG1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 02:27:24 -0400
Date: Tue, 6 May 2008 09:26:14 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: warn about complex selects
Message-ID: <20080506062614.GG1544@cs181133002.pp.htv.fi>
References: <20080504054044.GA32030@damson> <Pine.LNX.4.64.0805060511220.30555@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805060511220.30555@scrub.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 05:43:32AM +0200, Roman Zippel wrote:
> Hi,

Hi Roman,

>...
> It's not an impossible problem, but it's not trivial either, so that I 
> haven't spend any time on it and rather would like to spend the energy on 
> fixing the problem properly instead of working around it. And the problem 
> BTW isn't select itself, the problem is that all the Kconfig dependencies 
> have grown and become more complex, so it's becoming increasingly more 
> difficult to maintain and to use them - select was never meant to solve 
> this problem...

what do you consider the best solution?

Can we get it solved in kconfig?

Or should kconfig stay the same and use the pattern we already use
with SSB_POSSIBLE?

Or is there some better solution?

> bye, Roman

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

