Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbZGQVvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbZGQVvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 17:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbZGQVvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 17:51:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48483 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520AbZGQVvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 17:51:18 -0400
Date: Fri, 17 Jul 2009 23:51:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sage Weil <sage@newdream.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/20] ceph: debugging
Message-ID: <20090717215114.GC6173@basil.fritz.box>
References: <1247693090-27796-17-git-send-email-sage@newdream.net> <1247693090-27796-18-git-send-email-sage@newdream.net> <1247693090-27796-19-git-send-email-sage@newdream.net> <87d480x16p.fsf@basil.nowhere.org> <Pine.LNX.4.64.0907161014330.8026@cobra.newdream.net> <Pine.LNX.4.64.0907171010470.23194@cobra.newdream.net> <20090717185641.GH8046@one.firstfloor.org> <Pine.LNX.4.64.0907171247570.23194@cobra.newdream.net> <20090717200114.GA6173@basil.fritz.box> <Pine.LNX.4.64.0907171433060.23194@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907171433060.23194@cobra.newdream.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is that really a concern when compiling with DEBUG or 
> CONFIG_DYNAMIC_DEBUG? 

I would expect that CONFIG_DYNAMIC_DEBUG=1 is moving
into distribution/production kernels. It simply
makes a lot of debugging much easier. For you
later that would be also useful, if you have 
a user report about some misbehaviour and you
need more debug output it is much
easier to tell them to enable flag X than to 
recompile.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
