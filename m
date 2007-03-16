Return-Path: <linux-kernel-owner+w=401wt.eu-S965801AbXCPRz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965801AbXCPRz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965804AbXCPRz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:55:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:37583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965801AbXCPRz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:55:27 -0400
Date: Fri, 16 Mar 2007 10:53:16 -0700
From: Greg KH <greg@kroah.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Greg KH <gregkh@suse.de>
Subject: Re: [patch 24/26] Xen-paravirt_ops: Add the Xenbus sysfs and virtual device hotplug driver.
Message-ID: <20070316175316.GA17091@kroah.com>
References: <20070301232443.195603797@goop.org> <20070301232529.271605211@goop.org> <20070316084704.GB23174@elte.hu> <20070316161804.GH10574@sequoia.sous-sol.org> <20070316161948.GE9413@elte.hu> <20070316164023.GJ10574@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316164023.GJ10574@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2007 at 09:40:23AM -0700, Chris Wright wrote:
> * Ingo Molnar (mingo@elte.hu) wrote:
> > please indicate any such review feedback (and approval) via 
> > signed-off-by lines done by that person.
> 
> Certainly, Greg didn't sign off, he simply gave review feedback.

Yeah, I did that a while ago, but I don't want to give my acked-by or
signed-off for this code.  While I can not find anything specfically
wrong with it, it seems a bit "odd", but that might just be because I
really don't understand what they are doing here, or why.

And no, I really don't want to understand it either at the moment due to
being busy with other things :)

thanks,

greg k-h
