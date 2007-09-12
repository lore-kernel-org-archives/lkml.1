Return-Path: <linux-kernel-owner+w=401wt.eu-S970711AbXILRJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970711AbXILRJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967206AbXILRJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:09:26 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:45650 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764811AbXILRJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:09:26 -0400
Date: Wed, 12 Sep 2007 19:09:30 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@linux.intel.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [1/4] 2.6.23-rc6: known regressions
Message-ID: <20070912170930.GA3563@stusta.de>
References: <46E81AC6.3000306@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46E81AC6.3000306@googlemail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 06:58:46PM +0200, Michal Piotrowski wrote:
> Hi all,
>...
> Subject         : uml on x86_64 compile error
> References      : http://lkml.org/lkml/2007/9/3/86
> Last known good : ?
> Submitter       : Adrian Bunk <bunk@kernel.org>
> Caused-By       : Jeff Dike <jdike@linux.intel.com>
>                   commit d1254b12c93e1e586137a2ffef71fd33cf273f35
> Handled-By      : ?
> Status          : unknown

This one was fixed by commit 980abe215b861891c39aba0936817c46f372143b

> Regards,
> Michal

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

