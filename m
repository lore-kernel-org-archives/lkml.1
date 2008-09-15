Return-Path: <linux-kernel-owner+w=401wt.eu-S1756987AbYIOWiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbYIOWiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 18:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbYIOWiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 18:38:10 -0400
Received: from havoc.gtf.org ([69.61.125.42]:38368 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbYIOWiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 18:38:09 -0400
Date: Mon, 15 Sep 2008 18:38:07 -0400
From: Jeff Garzik <jeff@garzik.org>
To: David Miller <davem@davemloft.net>
Cc: tsbogend@alpha.franken.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
Message-ID: <20080915223807.GC15421@havoc.gtf.org>
References: <20080915204543.GD3994@havoc.gtf.org> <20080915.141442.139271313.davem@davemloft.net> <20080915215307.GA10340@alpha.franken.de> <20080915.151125.93659986.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915.151125.93659986.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 03:11:25PM -0700, David Miller wrote:
> There are a lot of clean and good fixes, but that is not the
> criteria for outside-of-the merge-window submissions right now.
> 
> Linus has made this clear.

He continues to take non-regression fixes and minor cosmetic commits
from other trees.

The basic idea is to BALANCE the lateness of -rc with the seriousness of
the problem being fixed, and the technical complexity of the fix itself.

The later the -rc, the more you need to take into account how likely it
is to create additional problems.  But did you READ the patches and
extended commit descriptions, to see if additional problems were likely?

Late -rc does not mean "no bug fixes at all except regressions" if you
look at the commits going into the kernel tree.

Late -rc does not mean putting off memory corruption fixes for 6 months.

	Jeff



