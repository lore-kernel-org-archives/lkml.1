Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZALQRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZALQRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 11:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZALQQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 11:16:56 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:35529 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbZALQQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 11:16:55 -0500
Subject: Re: [Patch 0/3] Overview, OProfile SPU event profiling support for
	IBM Cell processor
From: Carl Love <cel@us.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Robert Richter <robert.richter@amd.com>, linuxppc-dev@ozlabs.org,
       cel <cel@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       oprofile-list@lists.sourceforge.net,
       cbe-oss-dev <cbe-oss-dev@ozlabs.org>
In-Reply-To: <1231630269.2142.91.camel@pasglop>
References: <1228177106.6509.285.camel@carll-linux-desktop>
	 <20090108154835.GQ15411@erda.amd.com>
	 <1231460791.6621.54.camel@carll-linux-desktop>
	 <1231630269.2142.91.camel@pasglop>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 08:15:27 -0800
Message-Id: <1231776927.6621.112.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2009-01-11 at 10:31 +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2009-01-08 at 16:26 -0800, Carl Love wrote:
> > I pulled down the git tree, compiled and installed it.  I tested it
> > against the OProfile testsuite, which includes SPU event profiling
> > tests.  Everything passed.  The patch I submitted was against a 2.6.26
> > tree.  You are now on a 2.6.28 tree so perhaps that is why the patch did
> > not apply cleanly.  The patch has been out there for some time.  
> 
> When you submited it on Dec 2, it should have been against whatever was
> the latest upstream at the time, not 2.6.26.
> 
> Cheers,
> Ben.

Ben, Arnd and Robert:

The patch was against the latest Arnd Cell Kernel tree at the time it
was posted. The OProfile for cell patches have all been submitted,
accepted by Arnd (CELL Kernel maintainer) and pushed up stream by Arnd.
Arnd has waited for the OProfile maintainer to review and approve the
change before Arnd would push it upstream.  

So, at this point, Robert's (OProfile kernel maintainer) and Maynard's
(OProfile user space maintainer) approval for the patches.  

The question now goes to Arnd and Robert, who is going to push the
patches upstream?  Looks like Robert is ready to do it, so Arnd do you
approve the patches?  Would you like to have Robert push the patches
upstream or would you prefer to do it?  I think we need an
answer/agreement on this.  

                 Carl Love


