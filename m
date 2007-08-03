Return-Path: <linux-kernel-owner+w=401wt.eu-S1762921AbXHCUBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762921AbXHCUBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 16:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbXHCUBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 16:01:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbXHCUBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 16:01:15 -0400
Date: Fri, 3 Aug 2007 12:56:18 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Oliver Neukum <oliver@neukum.org>,
       Rogan Dawes <lists@dawes.za.net>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net, zaitcev@redhat.com
Subject: Re: [PATCH] USB: Only enable autosuspend by default on certain
 device classes
Message-Id: <20070803125618.36ea1b2f.zaitcev@redhat.com>
In-Reply-To: <46B38211.4030004@redhat.com>
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org>
	<200708022301.08719.david-b@pacbell.net>
	<20070803112824.GA16802@srcf.ucam.org>
	<200708031344.03282.oliver@neukum.org>
	<20070803120418.GB16802@srcf.ucam.org>
	<46B31F03.80908@dawes.za.net>
	<20070803123253.GA17725@srcf.ucam.org>
	<20070803174435.GA17053@suse.de>
	<20070803174810.GA23241@srcf.ucam.org>
	<46B38211.4030004@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Aug 2007 15:29:21 -0400, Chuck Ebbert <cebbert@redhat.com> wrote:

> > Well, we did - with hindsight it may not have been such a great plan :) 
> > I believe that Fedora did as well, but have disabled it in an update 
> > kernel.
> 
> Yeah, autosuspend broke too many devices. Way too many.

Glad you chimed in, Chuck. I was wondering about it... I saw something
like 3 reports about broken printers, two of them for the same printer,
Samsung ML-2010. It's on the installed base of 300,000 to 500,000.
People simply do not report squat. Today DaveJ said that none of his
printers work, which sounds bad, and was news to me. But the point is,
we are trying to extrapolate from too few cases.

I am wondering if Ubuntu has better user reporting, so if Matthew
complains, it really means something.

-- Pete
