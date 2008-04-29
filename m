Return-Path: <linux-kernel-owner+w=401wt.eu-S1758483AbYD2Lsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483AbYD2Lsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbYD2LsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:48:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:51470 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755491AbYD2LsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:48:16 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19wd0BooYJw5+MJdKbSdlVxEs+h8otg1MRcenj7GH
	gXl7DLutzJrSrv
Date: Tue, 29 Apr 2008 13:48:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] video: fix SOC_CAMERA_MT9M001 build bug
In-Reply-To: <20080428201105.GD15840@elte.hu>
Message-ID: <Pine.LNX.4.64.0804291345050.5602@axis700.grange>
References: <20080428120032.GA23847@elte.hu> <Pine.LNX.4.64.0804281944100.10718@axis700.grange>
 <20080428193130.GC9907@elte.hu> <Pine.LNX.4.64.0804282138000.11449@axis700.grange>
 <20080428201105.GD15840@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, Ingo Molnar wrote:

> sorry, you are right. Mind doing the right patch as you know this code 
> much better than i do?

Mauro, as you've already committed Ingo's patch to your hg tree, what's 
the best way to fix this? Should a revert be committed, or would you drop 
that patch? The latter would be better, I guess, but then I better wait 
for you to do it, then update against your new tree, and then add a 
correct fix, right?

Thanks
Guennadi
---
Guennadi Liakhovetski
