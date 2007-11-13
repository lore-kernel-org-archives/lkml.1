Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbXKMVhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbXKMVhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763572AbXKMVhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:37:25 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34925 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763423AbXKMVhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:37:23 -0500
Date: Tue, 13 Nov 2007 22:37:01 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Kujau <lists@nerdbynature.de>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071113213701.GN4250@stusta.de>
References: <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113.043207.44732743.davem@davemloft.net> <20071113110259.44c56d42.akpm@linux-foundation.org> <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de> <20071113130411.26ccae12.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071113130411.26ccae12.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 01:04:11PM -0800, Andrew Morton wrote:
>...
> Here's an important point: developers have a fixed amount of development
> time.  They spend some of that time fixing bugs and the rest of that time
> on <otherstuff>.  And while one could cook up all sorts of wonderful
> process changes, they all would be aimed at a single thing: shifting some
> of the developers' time away from <otherstuff> and onto bugfixing.
>...

There is another possible solution:
Finding more maintainers.

The problem seems to be that there are many people who want to write 
drivers for cool shiny new hardware, but not many people willing to
learn to know and maintain existing code.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

