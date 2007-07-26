Return-Path: <linux-kernel-owner+w=401wt.eu-S1764464AbXGZGHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764464AbXGZGHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 02:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbXGZGHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 02:07:39 -0400
Received: from ns.suse.de ([195.135.220.2]:55402 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478AbXGZGHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 02:07:38 -0400
Date: Wed, 25 Jul 2007 22:46:00 -0700
From: Greg KH <gregkh@suse.de>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][resend] sysfs/file.c - use mutex instead of semaphore
Message-ID: <20070726054600.GA25263@suse.de>
References: <20070726110354.GA3672@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726110354.GA3672@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 11:03:54AM +0000, Dave Young wrote:
> Use mutex instead of semaphore in sysfs/file.c : sys_buffer.

Thanks, it's in my queue, but I'm at a conference this week, so I'll get
to it on monday, sorry for the delay.

greg k-h
