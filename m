Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab0CCAHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:07:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab0CCAHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:07:50 -0500
Date: Tue, 2 Mar 2010 16:02:05 -0800
From: Greg KH <gregkh@suse.de>
To: Ari Entlich <atrigent@ccs.neu.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/36] tty: Add a new VT mode which is like VT_PROCESS
 but doesn't require a VT_RELDISP ioctl call
Message-ID: <20100303000205.GA2891@suse.de>
References: <14018832.317861267574035528.JavaMail.root@zimbra>
 <12806278.317911267574120161.JavaMail.root@zimbra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12806278.317911267574120161.JavaMail.root@zimbra>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 06:55:20PM -0500, Ari Entlich wrote:
> Hello!
> 
> Could you please remove this patch from your 2.6.34 tty pull request?
> Andrew Morton questioned whether this should actually be used yet[1],
> and I responded confirming his suspicions[2]. In addition, this patch
> has not "been in the linux-next and -mm releases for a number of
> weeks now", as you suggest in your pull request.

Hm, it's been there for over a week from what I can tell, right?

I'll revert it after this batch goes into Linus's tree.  Next time, warn
me a bit earlier :)

thanks,

greg k-h
