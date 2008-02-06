Return-Path: <linux-kernel-owner+w=401wt.eu-S1763503AbYBFMca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763503AbYBFMca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 07:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762303AbYBFMcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 07:32:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50293
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762151AbYBFMcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 07:32:17 -0500
Date: Wed, 06 Feb 2008 04:32:46 -0800 (PST)
Message-Id: <20080206.043246.63923682.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [bug] networking broke, ssh: connect to port 22: Protocol error
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080206122248.GA5233@elte.hu>
References: <20080206113829.GA14793@elte.hu>
	<20080206.034243.243568099.davem@davemloft.net>
	<20080206122248.GA5233@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 6 Feb 2008 13:22:48 +0100

> So no, it does not fix the problem. The config i sent is a rather 
> generic one, it should boot on most whitebox PCs. TCP connections will 
> fail immediately, all the time.

I suspect this got added recently with how often and how thoroughly
you test things :-)

If you can only give us the last GIT head that worked on that machine
it might help us narrow things down a lot.

If you have time for a bisect, even better but not absolutely
required.
