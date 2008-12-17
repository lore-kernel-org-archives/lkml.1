Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752308AbYLQMG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbYLQMG5 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYLQMGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:06:35 -0500
Received: from adelie.canonical.com ([91.189.90.139]:50700 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbYLQMGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:06:34 -0500
Subject: Re: [PATCH 0/7] Ksplice: Rebootless kernel updates
From: Ben Collins <bcollins@ubuntu.com>
Reply-To: Ben Collins <ben.collins@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tim Abbott <tabbott@MIT.EDU>, Jeff Arnold <jbarnold@MIT.EDU>,
        linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
        Nikanth Karthikesan <knikanth@suse.de>,
        Dave Jones <davej@codemonkey.org.uk>
In-Reply-To: <20081216190740.9db323ee.akpm@linux-foundation.org>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu>
	 <alpine.DEB.2.00.0812162133360.25958@vinegar-pot.mit.edu>
	 <20081216190740.9db323ee.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Canonical
Date: Wed, 17 Dec 2008 07:06:07 -0500
Message-Id: <1229515567.9540.20.camel@capable>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-16 at 19:07 -0800, Andrew Morton wrote:
> On Tue, 16 Dec 2008 21:48:29 -0500 (EST) Tim Abbott <tabbott@MIT.EDU> wrote:
> 
> > On Fri, 5 Dec 2008, Jeff Arnold wrote:
> > 
> > > We're interested in having Ksplice included in -mm.  If you could consider
> > > this code for inclusion (or let us know what you'd like us to do next),
> > > we'd appreciate it.
> > 
> > Hi Andrew,
> > 
> > Since it's been a couple of weeks, I thought that I would ask whether you 
> > know yet how you'd like to handle this patch series.  Thanks,
> > 
> 
> It's quite a lot of tricky code, and fairly high maintenance, I expect.
> 
> I'd have _thought_ that distros and their high-end customers would be
> interested in it, but I haven't noticed anything from them.  Not that
> this means much - our processes for gathering this sort of information
> are rudimentary at best.  Has your team been in contact with distros?
> Are Suse shipping it, or planning to?
> 
> (cc's a few more distro people)
> 
> Guys, could you please wander over to the appropriate cube and
> administer a prod?

We aren't using it and I haven't heard any requests for it. Might check
it out though.

