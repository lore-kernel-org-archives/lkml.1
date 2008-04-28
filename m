Return-Path: <linux-kernel-owner+w=401wt.eu-S932803AbYD1Hqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbYD1Hqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765659AbYD1Hq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:46:29 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34470 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763414AbYD1Hq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:46:28 -0400
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20080427192037.5af6b3f3.akpm@linux-foundation.org> (message from
	Andrew Morton on Sun, 27 Apr 2008 19:20:37 -0700)
Subject: Re: [patch 0/5] fuse updates
References: <20080425175520.735386844@szeredi.hu> <20080427192037.5af6b3f3.akpm@linux-foundation.org>
Message-Id: <E1JqO48-0003yk-Fv@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 28 Apr 2008 09:46:24 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > These are fuse fixes for 2.6.26.  Please apply.
> > 
> 
> Are none of them needed in 2.6.25.x?

Not really.  All of them are minor issues, and some of them fix
regressions by the fuse patches already in -mm.

Thanks,
Miklos
