Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbYJWU15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbYJWU15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 16:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYJWU1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 16:27:48 -0400
Received: from mx1.suse.de ([195.135.220.2]:50021 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbYJWU1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 16:27:47 -0400
Date: Thu, 23 Oct 2008 13:22:53 -0700
From: Greg KH <gregkh@suse.de>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hiroshi Miura <miura@da-cha.org>,
       YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
       Harald Welte <laforge@gnumonks.org>, linux-acpi@vger.kernel.org
Subject: Re: [GIT PATCH] delete pcc_acpi
Message-ID: <20081023202253.GA16659@suse.de>
References: <20081022172203.GA4000@kroah.com> <1224696563-5170-1-git-send-email-gregkh@suse.de> <alpine.LFD.1.10.0810221434070.3010@localhost.localdomain> <20081022184808.GA24150@suse.de> <alpine.LFD.1.10.0810222244130.3010@localhost.localdomain> <alpine.LFD.1.10.0810231525070.3005@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0810231525070.3005@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 03:26:47PM -0400, Len Brown wrote:
> Hi Linus,
> 
> please pull from: 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> 
> this old driver errantly went upstream with the staging stuff, but should 
> not have.
> 
> This will update the files shown below.

I ack this pull, thanks, I didn't see this driver already in Len's tree
when I added it to the staging tree, my apologies.

thanks,

greg k-h
