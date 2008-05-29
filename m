Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbYE2V7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbYE2V7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbYE2V7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:59:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:52860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbYE2V7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:59:20 -0400
Date: Thu, 29 May 2008 14:58:08 -0700
From: Greg KH <gregkh@suse.de>
To: David Brownell <david-b@pacbell.net>,
       Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB fixes for 2.6.26-rc4
Message-ID: <20080529215808.GA3759@suse.de>
References: <20080529212110.GA2870@suse.de> <200805291448.40075.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805291448.40075.david-b@pacbell.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 02:48:39PM -0700, David Brownell wrote:
> On Thursday 29 May 2008, Greg KH wrote:
> >       USB: EHCI: fix performance regression
> 
> That's not a regresssion at all!  Plus, this patch shouldn't
> have included the timeout change.  The timeout change is why
> I didn't ACK this patch...

Well, I was misinformed by Alan Stern about this then, sorry for missing
that you didn't ack this one (you acked the other patches in this series
though.)

Alan, care to make up a patch to fix this?  Or should I just revert it
in the tree as-is?

thanks,

greg k-h
