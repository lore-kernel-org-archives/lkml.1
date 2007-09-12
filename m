Return-Path: <linux-kernel-owner+w=401wt.eu-S1764457AbXILNOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764457AbXILNOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 09:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbXILNOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 09:14:20 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:35962
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757901AbXILNOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 09:14:19 -0400
Date: Wed, 12 Sep 2007 06:14:01 -0700 (PDT)
Message-Id: <20070912.061401.38698144.davem@davemloft.net>
To: bunk@kernel.org
Cc: akpm@linux-foundation.org, robert.olsson@its.uu.se,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [-mm patch] really unexport do_softirq
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070909202540.GU3563@stusta.de>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
	<20070909202540.GU3563@stusta.de>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Sun, 9 Sep 2007 22:25:40 +0200

> On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.23-rc3-mm1:
> >...
> >  git-net.patch
> >...
> >  git trees
> >...
> 
> This hydra had more than one head...
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied, thanks.
