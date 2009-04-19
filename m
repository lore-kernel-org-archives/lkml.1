Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbZDSERB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbZDSERB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 00:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbZDSEQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 00:16:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37450
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbZDSEQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 00:16:51 -0400
Date: Sat, 18 Apr 2009 21:16:43 -0700 (PDT)
Message-Id: <20090418.211643.248446717.davem@davemloft.net>
To: eric@anholt.net
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       airlied@linux.ie
Subject: Re: [git pull] Fixes to 2.6.30rc2
From: David Miller <davem@davemloft.net>
In-Reply-To: <1240086216.11172.2954.camel@gaiman.anholt.net>
References: <1240001399.11172.121.camel@gaiman.anholt.net>
	<20090418.015905.92829818.davem@davemloft.net>
	<1240086216.11172.2954.camel@gaiman.anholt.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Anholt <eric@anholt.net>
Date: Sat, 18 Apr 2009 13:23:36 -0700

> On Sat, 2009-04-18 at 01:59 -0700, David Miller wrote:
>> Eric, any plans to ever push your work through David Airlie's DRM
>> tree?  I've been watching this for a few weeks and I'm mystified why
>> the Intel DRM drier stuff is so special that is always goes seperate.
>> 
>> It's seems foolish for David to manage the infrastructure and core DRM
>> changes, as well as those for radeon and the other drivers other than
>> Intel, which could potentially cause merge issues and conflicts with
>> your driver changes.
>> 
>> Why not do Intel DRM driver development via his tree?  I just don't
>> get it. :-/
> 
> Inside of the merge window, I am going through Dave again because he
> requested it (though delays meant that I didn't get a major cleanup in
> this merge window).  However, Dave is also quite busy, and not stealing
> his time every few days to pull my tree for just forwarding bugfixes on
> seems to be a win.

So you're essentially claiming that Dave isn't being a responsive
enough maintainer of the DRM subsystem?
