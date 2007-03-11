Return-Path: <linux-kernel-owner+w=401wt.eu-S932488AbXCKVRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488AbXCKVRK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 17:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932403AbXCKVRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 17:17:10 -0400
Received: from ns2.suse.de ([195.135.220.15]:35414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932488AbXCKVRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 17:17:09 -0400
Date: Sun, 11 Mar 2007 22:17:07 +0100
From: Bernhard Walle <bwalle@suse.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Initialise SAK member for each virtual console to prevent oops
Message-ID: <20070311211706.GA21512@strauss.suse.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20070311204137.GD12950@strauss.suse.de> <20070311.135251.21926684.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311.135251.21926684.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller <davem@davemloft.net> [2007-03-11 21:52]:
> > +	    /* INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK); */
> 
> The code is commented out, so it won't do anything.

Sorry, you're right. I commented the line out just to generate again
the oops message to write the patch description because it was lost in
my minicom buffer.

I'll resend the patch.


Regards,
Bernhard
