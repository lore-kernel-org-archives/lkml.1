Return-Path: <linux-kernel-owner+w=401wt.eu-S1764287AbXF1DGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764287AbXF1DGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 23:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763897AbXF1DGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 23:06:15 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46681 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763739AbXF1DGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 23:06:14 -0400
Date: Thu, 28 Jun 2007 13:06:04 +1000
From: David Chinner <dgc@sgi.com>
To: mmarek@suse.cz
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] Fix XFS_IOC_FSGEOMETRY_V1 in compat mode
Message-ID: <20070628030603.GC989688@sgi.com>
References: <20070619132549.266927601@suse.cz> <20070619132726.360453113@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619132726.360453113@suse.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 03:25:50PM +0200, mmarek@suse.cz wrote:
> i386 struct xfs_fsop_geom_v1 has no padding after the last member, so
> the size is different.

Looks good. Added to my qa tree...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
