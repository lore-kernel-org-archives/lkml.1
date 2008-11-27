Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbYK0Qbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbYK0Qbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 11:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYK0Qbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 11:31:31 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44662 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYK0Qba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:31:30 -0500
To: sfr@canb.auug.org.au
CC: miklos@szeredi.hu, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tj@kernel.org
In-reply-to: <20081127022036.1dd0e2e6.sfr@canb.auug.org.au> (message from
	Stephen Rothwell on Thu, 27 Nov 2008 02:20:36 +1100)
Subject: Re: [linux-next] fuse tree
References: <E1L5Ia7-0001gb-2X@pomaz-ex.szeredi.hu> <20081127022036.1dd0e2e6.sfr@canb.auug.org.au>
Message-Id: <E1L5jly-0004ZD-SG@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 27 Nov 2008 17:31:22 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008, Stephen Rothwell wrote:
> On Wed, 26 Nov 2008 12:29:19 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > Could you please add the following git tree, containing fuse patches
> > to be included in 2.6.29, to the linux-next lineup?
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-next
> 
> I have added it for tomorrow's tree.

Thanks Stephen.

> 
> What I tell everyone: all patches in that branch must have been
> 	posted to a relevant mailing list
> 	reviewed
> 	unit tested
> 	destined for the next merge window (or the current release)
> *before* they are included.

Ack.

Thanks,
Miklos
