Return-Path: <linux-kernel-owner+w=401wt.eu-S1762211AbXHFAwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762211AbXHFAwm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 20:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXHFAwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 20:52:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52173 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752065AbXHFAwe (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 20:52:34 -0400
Date: Mon, 6 Aug 2007 10:52:14 +1000
From: David Chinner <dgc@sgi.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, xfs-masters@oss.sgi.com
Subject: Re: [PATCH][RESEND] fix a potential NULL pointer deref in XFS on failed mount.
Message-ID: <20070806005214.GK31489@sgi.com>
References: <200708042030.21375.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708042030.21375.jesper.juhl@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 08:30:21PM +0200, Jesper Juhl wrote:
> Back in 2006 (2006-10-31 to be specific, reposted on 2006-11-16), I 
> submitted a patch to fix a potential NULL pointer deref in XFS on 
> failed mount.

Already checked into xfs-dev tree. Will go to next mainline merge.

http://oss.sgi.com/archives/xfs/2007-08/msg00030.html

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
