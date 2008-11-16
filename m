Return-Path: <linux-kernel-owner+w=401wt.eu-S1752636AbYKPH4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbYKPH4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 02:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYKPH4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 02:56:41 -0500
Received: from fgwnews.fujitsu.co.jp ([164.71.1.134]:50492 "EHLO
	fgwnews.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbYKPH4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 02:56:41 -0500
X-Greylist: delayed 1045 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Nov 2008 02:56:40 EST
Date: Sun, 16 Nov 2008 16:56:15 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] vmscan: bail out of page reclaim after swap_cluster_max pages
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20081115235410.2d2c76de.akpm@linux-foundation.org>
References: <20081116163915.F208.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081115235410.2d2c76de.akpm@linux-foundation.org>
Message-Id: <20081116165533.F20B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I'll need to find some time to go dig through the changelogs.  
> > 
> > as far as I tried, git database doesn't have that changelogs.
> > FWIW, I guess it is more old.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/old-2.6-bkcvs.git
> goes back to 2.5.20 (iirc).

Wow!
I'll try it.

Thanks!!

