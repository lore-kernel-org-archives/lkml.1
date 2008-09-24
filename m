Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbYIXXDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbYIXXDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 19:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbYIXXDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 19:03:30 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:13416 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528AbYIXXDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 19:03:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAItj2kh5LF82/2dsb2JhbAC9UIFl
X-IronPort-AV: E=Sophos;i="4.33,303,1220193000"; 
   d="scan'208";a="214073458"
Date: Thu, 25 Sep 2008 09:03:26 +1000
From: Dave Chinner <david@fromorbit.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.27-rc7 no init found on the root partition?
Message-ID: <20080924230326.GM5448@disturbed>
Mail-Followup-To: Lukas Hejtmanek <xhejtman@ics.muni.cz>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com
References: <20080924192227.GC31582@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924192227.GC31582@ics.muni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 09:22:27PM +0200, Lukas Hejtmanek wrote:
> Hello,
> 
> I have a box that has XFS root partition, I have kernel 2.6.26.3 that boots
> pretty well on that box. Today, I've tried 2.6.27-rc7 (so that I can test
> NFSv4 over IPv6), but the kernel is unable to boot. It says that root
> partition is mounted, XFS file system but no init found.

Can you paste the error messages or send pointers to screen shots of
the error?

If you go back to 2.6.26.3, does the kernel boot ok?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
