Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757911AbYLQDIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbYLQDIc (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 22:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbYLQDIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 22:08:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbYLQDIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 22:08:20 -0500
Date: Tue, 16 Dec 2008 19:07:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Jeff Arnold <jbarnold@MIT.EDU>, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
        Nikanth Karthikesan <knikanth@suse.de>,
        Ben Collins <bcollins@ubuntu.com>,
        Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH 0/7] Ksplice: Rebootless kernel updates
Message-Id: <20081216190740.9db323ee.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0812162133360.25958@vinegar-pot.mit.edu>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu>
	<alpine.DEB.2.00.0812162133360.25958@vinegar-pot.mit.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 21:48:29 -0500 (EST) Tim Abbott <tabbott@MIT.EDU> wrote:

> On Fri, 5 Dec 2008, Jeff Arnold wrote:
> 
> > We're interested in having Ksplice included in -mm.  If you could consider
> > this code for inclusion (or let us know what you'd like us to do next),
> > we'd appreciate it.
> 
> Hi Andrew,
> 
> Since it's been a couple of weeks, I thought that I would ask whether you 
> know yet how you'd like to handle this patch series.  Thanks,
> 

It's quite a lot of tricky code, and fairly high maintenance, I expect.

I'd have _thought_ that distros and their high-end customers would be
interested in it, but I haven't noticed anything from them.  Not that
this means much - our processes for gathering this sort of information
are rudimentary at best.  Has your team been in contact with distros?
Are Suse shipping it, or planning to?

(cc's a few more distro people)

Guys, could you please wander over to the appropriate cube and
administer a prod?

Thanks.
