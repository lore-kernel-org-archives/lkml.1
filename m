Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbYFSK4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbYFSK4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 06:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbYFSK4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 06:56:07 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:60857
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755690AbYFSK4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 06:56:05 -0400
X-Trace: 99812947/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$ACCEPTED/freedom2Surf-customers/195.137.94.162
X-SBRS: None
X-RemoteIP: 195.137.94.162
X-IP-MAIL-FROM: spyro@f2s.com
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArQAAK3XWUjDiV6i/2dsb2JhbAAIsCw
X-IronPort-AV: E=Sophos;i="4.27,672,1204502400"; 
   d="scan'208";a="99812947"
X-IP-Direction: IN
Subject: Re: [PATCH] MFD maintainer
From: ian <spyro@f2s.com>
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: Samuel Ortiz <sameo@openedhand.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Dooks <ben-linux@fluff.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
In-Reply-To: <74d0deb30806190259l2ff7931fo819ededc7aec02f7@mail.gmail.com>
References: <20080618214223.GE22566@caravaggio>
	 <74d0deb30806190259l2ff7931fo819ededc7aec02f7@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 11:54:41 +0100
Message-Id: <1213872881.17281.32.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys!

Good timing! I just sat down with the e-series code last night!

I'd like to see the MFD core make it into mainline, and then we can
start pushing the TMIO drivers too.

These drivers are in a LOT of handhelds and I'd really like to see the
code move to mainline now.

The code is maturing well - I just bumped all the eseries stuff, which
includes the core MFD code and all the TMIO drivers from 2.6.24 to
2.6.26-git and the only issue was some minor #include breakage.

I'll tidy up the code and pop a branch on my git server for people to
review, if thats what people want.

Dmitry - if you have any pending patches now is the time to send them on
over ;-)

-Ian

On Thu, 2008-06-19 at 11:59 +0200, pHilipp Zabel wrote:
> Added Ian, Dmitry and Russell to Cc.
> 
> On Wed, Jun 18, 2008 at 11:42 PM, Samuel Ortiz <sameo@openedhand.com> wrote:
> > Hi,
> >
> > We probably need someone to look after the few drivers/mfd patches coming
> > every now and then. As agreed with Andrew, I'm ok to do so and my employer
> > is fine with me spending a few working hours on it, if needed.
> 
> Right now quite some of the MFD patches go through arm-kernel, but I
> guess once that initial rush of ARM machine patches depending on MFD
> patches submitted at the same time is over, it's a very good idea to
> have a proper path into the kernel.

