Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbXGAWcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbXGAWcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 18:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbXGAWcC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 18:32:02 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52565 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751484AbXGAWcA (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 18:32:00 -0400
Date: Mon, 2 Jul 2007 08:31:48 +1000
From: David Chinner <dgc@sgi.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][XFS][resend] fix memory leak in xfs_inactive()
Message-ID: <20070701223147.GU31489@sgi.com>
References: <200707010116.52012.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707010116.52012.jesper.juhl@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2007 at 01:16:51AM +0200, Jesper Juhl wrote:
> (this is back from May 16 2007, resending since it doesn't look like 
> the patch ever made it in anywhere)

http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/fs/xfs/xfs_vnodeops.c.diff?r1=1.698;r2=1.699;f=h

Will get merged in 2.6.23-rc1 window.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
