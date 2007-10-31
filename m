Return-Path: <linux-kernel-owner+w=401wt.eu-S1759882AbXJaQ0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759882AbXJaQ0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbXJaQZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:25:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52983 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060AbXJaQZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:25:57 -0400
Date: Wed, 31 Oct 2007 09:24:00 -0700
From: Greg KH <greg@kroah.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, mingo@elte.hu,
       stable <stable@kernel.org>
Subject: Re: [stable] [PATCH] lockdep: fix mismatched
	lockdep_depth/curr_chain_hash
Message-ID: <20071031162400.GA22117@kroah.com>
References: <20071031154313.15685.72379.stgit@ghaskins-t60p.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031154313.15685.72379.stgit@ghaskins-t60p.haskins.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 11:44:05AM -0400, Gregory Haskins wrote:
> Hi Greg,
>    Here is the backported version of the patch.  I applied it on top of
>    2.6.22.10.  Let me know if you have any issues.

Looks good, thanks.  I've added it to the -stable queue and will add it
to the current 2.6.22-stable release.

thanks,

greg k-h
