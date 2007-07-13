Return-Path: <linux-kernel-owner+w=401wt.eu-S934234AbXGMSKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934234AbXGMSKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932417AbXGMSKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:10:34 -0400
Received: from mail.fieldses.org ([66.93.2.214]:36892 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932390AbXGMSKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:10:33 -0400
Date: Fri, 13 Jul 2007 14:10:25 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org,
       "andros @ citi . umich . edu" <andros@citi.umich.edu>,
       "J . Bruce Fields" <bfields@puzzle.fieldses.org>,
       Usha Ketineni <ketineni@us.ibm.com>,
       Usha Ketineni <uketinen@us.ibm.com>
Subject: Re: [PATCH 000 of 20] knfsd: Support 'secinfo' exports with
	related cleanups
Message-ID: <20070713181025.GM12582@fieldses.org>
References: <20070710121949.12548.patches@notabene> <20070713003310.2df90a38.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713003310.2df90a38.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 12:33:10AM -0700, Andrew Morton wrote:
> On Tue, 10 Jul 2007 12:22:37 +1000 NeilBrown <neilb@suse.de> wrote:
> 
> > With this patchset it becomes possible to list a number of different
> > security flavours that maybe used to access an exported filesystem,
> > and to attach different export options (e.g. readonly, rootsquash) to
> > different flavours.
> > Also, NFSv4 can report which flavours are available on a particular export.
> 
> Please consider feeding knfsd patches through checkpatch in the future.  It
> did find several glitches in these patches which you might have chosen
> to address.

OK.  I guess I'll wait till the next -mm is out, take a look, and
address your comments then.  Thanks.--b.
