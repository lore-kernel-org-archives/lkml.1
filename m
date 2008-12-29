Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbYL2A3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbYL2A3d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 19:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbYL2A3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 19:29:14 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:22325 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755316AbYL2A3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 19:29:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AncDABipV0l5LB1fgWdsb2JhbACTcwEBFiKoPFiOYoZE
X-IronPort-AV: E=Sophos;i="4.36,293,1228051800"; 
   d="scan'208";a="283621748"
Date: Mon, 29 Dec 2008 11:28:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: Thomas Themel <thomas@themel.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS corruption on ARM
Message-ID: <20081229002851.GD22525@disturbed>
Mail-Followup-To: Thomas Themel <thomas@themel.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com
References: <20081228123305.GE30805@themel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081228123305.GE30805@themel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC'd the xfs list.]

On Sun, Dec 28, 2008 at 01:33:05PM +0100, Thomas Themel wrote:
> Hi,
> 
> there was a thread[0] on this list in 2008-10 about XFS corrupting
> rather quickly on recent ARM kernels, which seems to have petered out
> without any apparent results. I'm still seeing the same problems with
> 2.6.28, and I suspect that this qualifies as a kind of regression
> (though ancient), since the devices I'm running this on (Buffalo
> LinkStations) originally ship with a (vendor-modified) 2.6.16 kernel,
> where XFS seems to be working.
> 
> Is this still on anyone's radar? I'm willing to test proposed fixes and
> supply data[1], but lack any deep knowledge of either ARM or XFS internals.
> 
> (Please Cc: me, I'm not on the list.)
> 
> [0] http://lkml.org/lkml/2008/10/1/382
> [1] Though mine doesn't look any different from what was posted in [0]
>     to the little-trained eye.
> 
> ciao,
> -- 
> [*Thomas  Themel*]
> [extended contact] But let your communication be, Yea, yea; Nay, nay:
> [info provided in] for whatsoever is more than these cometh of evil.
> [*message header*]      - Matthew 5:37
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Dave Chinner
david@fromorbit.com
