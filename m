Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752858AbYLQMJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbYLQMJn (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbYLQMJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:09:32 -0500
Received: from adelie.canonical.com ([91.189.90.139]:52126 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbYLQMJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:09:31 -0500
Subject: Re: [PATCH 0/7] Ksplice: Rebootless kernel updates
From: Ben Collins <bcollins@ubuntu.com>
Reply-To: Ben Collins <ben.collins@canonical.com>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Arnold <jbarnold@MIT.EDU>,
        linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
        Nikanth Karthikesan <knikanth@suse.de>,
        Dave Jones <davej@codemonkey.org.uk>
In-Reply-To: <alpine.DEB.2.00.0812162211540.25958@vinegar-pot.mit.edu>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu>
	 <alpine.DEB.2.00.0812162133360.25958@vinegar-pot.mit.edu>
	 <20081216190740.9db323ee.akpm@linux-foundation.org>
	 <alpine.DEB.2.00.0812162211540.25958@vinegar-pot.mit.edu>
Content-Type: text/plain
Organization: Canonical
Date: Wed, 17 Dec 2008 07:09:09 -0500
Message-Id: <1229515749.9540.21.camel@capable>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-17 at 00:05 -0500, Tim Abbott wrote:
> On Tue, 16 Dec 2008, Andrew Morton wrote:
> 
> > Has your team been in contact with distros? Are Suse shipping it, or 
> > planning to?
> 
> We've talked to kernel team people from Fedora, Ubuntu, and SUSE so far. 
> Fedora 8, 9, and 10, Debian sid, and Ubuntu jaunty are currently shipping 
> packages for the standalone version of Ksplice.

Ubuntu jaunty isn't "shipping", just to be clear.

> We haven't yet made a big push for end-users--that's still ahead.  We've 
> submitted the code now because we think that it's important to try to 
> involve the community sooner rather than later.
> 
>  	-Tim Abbott

