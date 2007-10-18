Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbXJRPXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbXJRPXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbXJRPXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:23:23 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:49393 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbXJRPXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:23:22 -0400
Date: Fri, 19 Oct 2007 00:23:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/21] KGDB: Request to merge KGDB
Message-ID: <20071018152310.GA7299@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Wessel <jason.wessel@windriver.com>,
	lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
References: <4713B238.4030409@windriver.com> <20071017212025.d8a52694.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017212025.d8a52694.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 09:20:25PM -0700, Andrew Morton wrote:
> On Mon, 15 Oct 2007 13:32:24 -0500 Jason Wessel <jason.wessel@windriver.com> wrote:
> > This is a request to merge KGDB into the mainline kernel.  
> 
> This won't work very well.  There's a lot of review work to be done here,
> and a lot of it by busy architecture maintainers.  Expecting people to do
> all this review and test work late in the merge window when they're all
> madly scrambling to get their bugs^Wpatches into mainline is not reasonable.
> This should all have started a month ago.
> 
> So we're looking at a 2.6.25 merge for this work.  After this round of
> review has settled, please upissue the patches and keep linux-arch (cc'ed
> here) copied on everything, thanks.
> 
It would also be nice to balance this out with the utrace merge, as both
are going to cause quite a lot of pain on the architecture side.
