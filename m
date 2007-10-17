Return-Path: <linux-kernel-owner+w=401wt.eu-S933159AbXJQUhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbXJQUhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759849AbXJQUhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:37:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56277 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759777AbXJQUhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:37:05 -0400
Date: Wed, 17 Oct 2007 21:36:58 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Tim Shimmin <tes@sgi.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.24-rc1
Message-ID: <20071017203658.GA22073@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Tim Shimmin <tes@sgi.com>, torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	akpm@linux-foundation.org
References: <20071017110339.D4B3158C38F1@chook.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017110339.D4B3158C38F1@chook.melbourne.sgi.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 09:03:39PM +1000, Tim Shimmin wrote:
> Hi Linus,
> 
> Please pull from the for-linus branch:
>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
> 
> These include changes we have had scheduled for 2.6.24.
> In particular they include Christoph's (hch's) behavior removal patches.

Can you please send my '[PATCH] cleanup fid types mess' to Linus aswell?
I have a stack of 15 patches reworking the nfs exporting code waiting
in -mm to get in in this merge window that depend on this cleanup to
free struct fid for generic useage.

Also getting the makefile cleanup into mainline to reduce spurious difference
would help a lot.

