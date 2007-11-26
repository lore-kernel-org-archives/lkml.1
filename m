Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbXKZWrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbXKZWrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbXKZWrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 17:47:06 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38758 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbXKZWrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 17:47:03 -0500
Date: Mon, 26 Nov 2007 14:46:57 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Gary Hade <garyhade@us.ibm.com>, Jan Beulich <jbeulich@novell.com>,
       linux-kernel@vger.kernel.org, lcm@us.ibm.com
Subject: Re: Avoid creating P2P prefetch window for expansion ROMs
Message-ID: <20071126224657.GB23277@us.ibm.com>
References: <4742CB2C.76E4.0078.0@novell.com> <20071120174945.GA6024@us.ibm.com> <47440D1F.76E4.0078.0@novell.com> <20071126215953.GA23277@us.ibm.com> <20071126221545.GA15268@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126221545.GA15268@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 02:15:45PM -0800, Greg KH wrote:
> On Mon, Nov 26, 2007 at 01:59:54PM -0800, Gary Hade wrote:
> > Greg, 
> > Without a closer look at the code and the information I
> > requested above I am not 100% certain that my expansion ROM
> > allocation fix is incomplete but it seems pretty likely that
> > it is.  If you feel that the possible regression that Jan
> > reported is more important than the issue I was trying to solve
> > feel free to remove the change until I can come up with
> > something better.
> 
> If you want me to revert the changes in Linus's tree right now, that's
> fine, I will, just send me a patch to do so.
> 
> But if you think you can work to solve this problem quickly, then I'm
> more than willing to keep the changes in the tree.
> 
> It's up to you.

Thanks Greg.  If I am unable to provide a revised (or properly
defend the current one :) in the next few days I will send you
a revert patch.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
