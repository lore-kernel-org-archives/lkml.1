Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758456AbYLQFGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbYLQFGt (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbYLQFGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:06:37 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:51485 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755417AbYLQFGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:06:36 -0500
Date: Wed, 17 Dec 2008 00:05:10 -0500 (EST)
From: Tim Abbott <tabbott@MIT.EDU>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jeff Arnold <jbarnold@MIT.EDU>, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
        Nikanth Karthikesan <knikanth@suse.de>,
        Ben Collins <bcollins@ubuntu.com>,
        Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH 0/7] Ksplice: Rebootless kernel updates
In-Reply-To: <20081216190740.9db323ee.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0812162211540.25958@vinegar-pot.mit.edu>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <alpine.DEB.2.00.0812162133360.25958@vinegar-pot.mit.edu> <20081216190740.9db323ee.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008, Andrew Morton wrote:

> Has your team been in contact with distros? Are Suse shipping it, or 
> planning to?

We've talked to kernel team people from Fedora, Ubuntu, and SUSE so far. 
Fedora 8, 9, and 10, Debian sid, and Ubuntu jaunty are currently shipping 
packages for the standalone version of Ksplice.

We haven't yet made a big push for end-users--that's still ahead.  We've 
submitted the code now because we think that it's important to try to 
involve the community sooner rather than later.

 	-Tim Abbott
