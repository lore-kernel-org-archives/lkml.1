Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbYGNVIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbYGNVIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 17:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbYGNVIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 17:08:41 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36964 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbYGNVIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 17:08:41 -0400
Date: Mon, 14 Jul 2008 22:08:39 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm tree reorganisation for merge window
In-Reply-To: <20080715012153.a3bb9df0.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.0.82.0807142207010.3936@skynet.skynet.ie>
References: <alpine.DEB.0.82.0807140147500.9419@skynet.skynet.ie>
 <20080715012153.a3bb9df0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >
> > Please pull the 'drm-reorg' branch from
> > ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-reorg
> > 
> > This contains a moving around of a lot of the DRM into a more Linux like 
> > tree and makes it a lot nicer going forward for merging new features.
> 
> Does this tree have a fix for the x86_64 allmodconfig build failures I
> reported against linux-next?

Yes I rolled them into the patch instead of cluttering up the history.

Dave.
