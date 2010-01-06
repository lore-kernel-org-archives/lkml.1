Return-Path: <linux-kernel-owner+w=401wt.eu-S932691Ab0AFTwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab0AFTwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932677Ab0AFTwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:52:09 -0500
Received: from mga07.intel.com ([143.182.124.22]:60866 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932676Ab0AFTwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:52:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="229921201"
Date: Wed, 6 Jan 2010 20:53:40 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, ian@mnementh.co.uk, linux-sh@vger.kernel.org
Subject: Re: [PATCH] MMC: hardware abstraction for CNF area
Message-ID: <20100106195339.GD23473@sortiz.org>
References: <20100105050914.32264.762.sendpatchset@rxone.opensource.se>
 <20100106002158.GM4274@sortiz.org>
 <aec7e5c31001052057u68deaab2y1d63a2e881ef94a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec7e5c31001052057u68deaab2y1d63a2e881ef94a3@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Wed, Jan 06, 2010 at 01:57:09PM +0900, Magnus Damm wrote:
> 
> Thanks a lot for your help. I'll submit a patch on top of this one
> with fixes. Feel free to apply it on top or roll it in.
I rolled it into Ian's patch, and added an additional fix for one of the
toshiba mfd driver.
I applied the resulting patch to my tree, and will leave it there for at least
a couple days so that linux-next can pick it up.
Meanwhile, I'd really appreciate if Ian could make sure it works for him as
well. Ian, this is the patch I'm talking about:

http://git.kernel.org/?p=linux/kernel/git/sameo/mfd-2.6.git;a=commit;h=b3df6513659704ece28da3b80cc36c2a8de315ce

Cheers,
Samuel.


> Cheers,
> 
> / magnus

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
