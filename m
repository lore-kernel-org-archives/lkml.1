Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811Ab0AMMsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab0AMMsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 07:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439Ab0AMMsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 07:48:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:10536 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab0AMMsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 07:48:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,268,1262592000"; 
   d="scan'208";a="586761004"
Date: Wed, 13 Jan 2010 20:48:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX] cpufreq: dont BUG_ON uninitialized policy cpu
Message-ID: <20100113124811.GA8043@localhost>
References: <20100113051438.GA32519@localhost> <4B4DBFBC.4090400@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4DBFBC.4090400@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 08:42:36PM +0800, Thomas Renninger wrote:
> On 01/13/2010 06:14 AM, Wu Fengguang wrote:
> > Remove a BUG_ON which is always triggered here after commit 0b19a310eebb93:
> The patch got dropped from -mm.
> I hope it did not make it upstream yet, otherwise it should also
> get dropped/reverted there without replacement.
> There wasn't a real, only a theoretical issue.
> Looking at it again, I now think it's not needed at all.

It's still in linux-next. I wonder which sub-tree it belongs to..

Thanks,
Fengguang

