Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbYLVD73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbYLVD73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 22:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYLVD7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 22:59:21 -0500
Received: from mail.suse.de ([195.135.220.2]:60367 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbYLVD7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 22:59:20 -0500
Date: Mon, 22 Dec 2008 04:59:15 +0100
From: Nick Piggin <npiggin@suse.de>
To: venkatesh.pallipadi@intel.com
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, hugh@veritas.com, arjan@infradead.org,
       jbarnes@virtuousgeek.org, rdreier@cisco.com, jeremy@goop.org,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 0/5] Changes based on review comments for PAT pfnmap tracking
Message-ID: <20081222035915.GA13406@wotan.suse.de>
References: <20081219214725.125171000@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081219214725.125171000@intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 01:47:25PM -0800, venkatesh.pallipadi@intel.com wrote:
> Incremental patches to address the review comments from Nick Piggin
> for v3 version of x86 PAT pfnmap changes patchset here
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0812.2/01330.html

Thanks. Feel free to put Reviewed-by: / Acked-by: Nick Piggin <npiggin@suse.de>
on the generic mm patches which I reviewed after these changes if you like.
