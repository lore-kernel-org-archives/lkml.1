Return-Path: <linux-kernel-owner+w=401wt.eu-S1161186AbXDKFJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161186AbXDKFJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 01:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161194AbXDKFJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 01:09:20 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59337 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161186AbXDKFJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 01:09:19 -0400
Date: Tue, 10 Apr 2007 22:08:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] h8300 trivial conversion to GENERIC_TIME
Message-Id: <20070410220855.84fbcf78.akpm@linux-foundation.org>
In-Reply-To: <m2d52binwa.wl%ysato@users.sourceforge.jp>
References: <1176247500.15198.72.camel@localhost>
	<m2d52binwa.wl%ysato@users.sourceforge.jp>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 12:35:33 +0900 Yoshinori Sato <ysato@users.sourceforge.jp> wrote:

> At Tue, 10 Apr 2007 16:25:00 -0700,
> john stultz wrote:
> > 
> > Here is a trivial conversion of the h8300 arch to the GENERIC_TIME
> > infrastructure (h8300 does not have better then jiffies resolution, so
> > there are no clocksources to add). I have not tested this at all, but it
> > seems pretty straight forward
> > 
> > I'd appreciate any comments or feedback!
> > 
> > thanks
> > -john
> >
> 
> There will not be a problem.
> Because it is a place working now, I correct it if there 
> was a problem. 
> 
> > 
> > Signed-off-by: John Stultz <johnstul@us.ibm.com>
> Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>

This patch has actually been in -mm since Feb 27.  I'll merge it into
2.6.22-rc1, thanks.
