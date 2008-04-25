Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbYDYARt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbYDYARt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 20:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbYDYARl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 20:17:41 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:45732 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbYDYARk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 20:17:40 -0400
Date: Fri, 25 Apr 2008 03:16:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [git pull] ia64 changes
Message-ID: <20080425001652.GD18854@cs181133002.pp.htv.fi>
References: <1FE6DD409037234FAB833C420AA843EC012F9EF0@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC012F9EF0@orsmsx424.amr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 04:51:01PM -0700, Luck, Tony wrote:
>...
> Mike Travis (1):
>       Build fix for CONFIG_NUMA=y && CONFIG_SMP=n
>...

Why is this an allowed configuration on ia64?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

