Return-Path: <linux-kernel-owner+w=401wt.eu-S1763905AbYBBFtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763905AbYBBFtE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 00:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYBBFsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 00:48:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42545
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751106AbYBBFsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 00:48:51 -0500
Date: Fri, 01 Feb 2008 21:49:14 -0800 (PST)
Message-Id: <20080201.214914.156681650.davem@davemloft.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver updates #2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080201210338.GA11084@havoc.gtf.org>
References: <20080201210338.GA11084@havoc.gtf.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Fri, 1 Feb 2008 16:03:38 -0500

> This submit is based on top of Linus's tree, since I'm not sure what's
> going on with net-2.6.git and my previous (lost?) submission.
> 
> These changes do /not/ include anything from the previous submission,
> which was on top of net-2.6 -- but then you rebased, which probably made
> everything more difficult.  :)

Can you respin the tree with that previus submission init?

The best I'll be able to do is clone that entire tree in
order to pick the patches out, and from here in Australia
with a dodgy link I might not even finish before I have
to get on a plane back home on Monday :-)

I'll pull in this second set later tonight.
