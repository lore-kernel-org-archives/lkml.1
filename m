Return-Path: <linux-kernel-owner+w=401wt.eu-S1763457AbYD0Wwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763457AbYD0Wwf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 18:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYD0Ww1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 18:52:27 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34738 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbYD0Ww0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 18:52:26 -0400
Date: Sun, 27 Apr 2008 23:50:29 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Shi Weihua <shiwh@cn.fujitsu.com>,
       xemul@openvz.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [BUGFIX][PATCH] Fix usemap initialization v3
In-Reply-To: <4814D459.1020602@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0804272349450.16359@blonde.site>
References: <20080418161522.GB9147@csn.ul.ie> <48080706.50305@cn.fujitsu.com>
 <48080930.5090905@cn.fujitsu.com> <48080B86.7040200@cn.fujitsu.com>
 <20080418211214.299f91cd.kamezawa.hiroyu@jp.fujitsu.com>
 <21878461.1208539556838.kamezawa.hiroyu@jp.fujitsu.com>
 <20080421112048.78f0ec76.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0804211250000.16476@blonde.site>
 <20080422104043.215c7dc4.kamezawa.hiroyu@jp.fujitsu.com>
 <20080423134621.6020dd83.kamezawa.hiroyu@jp.fujitsu.com>
 <20080427121817.03b432ca.akpm@linux-foundation.org> <4814D459.1020602@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, Balbir Singh wrote:
> Andrew Morton wrote:
> > 
> > Do we think this is needed in 2.6.25.x?
> 
> My answer would be yes. Shi reproduced this problem with 2.6.25

Yes, that's my understanding too.

Hugh
