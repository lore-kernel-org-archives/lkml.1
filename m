Return-Path: <linux-kernel-owner+w=401wt.eu-S1161003AbXBTWrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161003AbXBTWrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161044AbXBTWrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:47:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:54039 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161003AbXBTWrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:47:45 -0500
Date: Tue, 20 Feb 2007 14:46:14 -0800
From: Greg KH <greg@kroah.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       torvalds@osdl.org, stable@kernel.org
Subject: Re: Linux 2.6.18.7
Message-ID: <20070220224614.GA4390@kroah.com>
References: <20070220065946.GA11688@kroah.com> <45DB688F.1070209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DB688F.1070209@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 04:30:55PM -0500, Chuck Ebbert wrote:
> Greg KH wrote:
> > We (the -stable team) are announcing the release of the 2.6.18.7 kernel.
> > It contains one NFS fix that if you run a NFS server, you might want to
> > apply.
> 
> Well that's nice.  There's at least one other unfixed CVE
> in 2.6.18.6 -- why didn't you fix that?  (The patch has been
> queued for two months now.)

I'm working on pushing the 2.6.18-stable queue out soon, sorry, been
backed up with other things recently.

I pushed this one out so quickly, as it was able to be triggered
remotely, unlike the current patches in the 2.6.18-stable queue.

thanks,

greg k-h
