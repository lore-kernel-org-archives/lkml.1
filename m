Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbYC1A7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbYC1A7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYC1A7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:59:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35014
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752127AbYC1A7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:59:39 -0400
Date: Thu, 27 Mar 2008 17:59:39 -0700 (PDT)
Message-Id: <20080327.175939.165029213.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: rjw@sisk.pl, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       netdev@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       marcus@better.se, shemminger@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [Bugme-new] [Bug 10326] New: inconsistent lock state in
 net_rx_action
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080327223913.GB3596@ami.dom.local>
References: <20080327222248.GA3596@ami.dom.local>
	<20080327.152218.235944668.davem@davemloft.net>
	<20080327223913.GB3596@ami.dom.local>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Thu, 27 Mar 2008 23:39:13 +0100

> On Thu, Mar 27, 2008 at 03:22:18PM -0700, David Miller wrote:
> ...
> > Instead of going back and forth like this can someone post
> > just take it upon themselves to post such an obvious patch
> > already :-)
> > 
> > All of this "he'll do it, she'll do it" just wastes time.
> 
> Right! She or he should also remember to add Peter's lockup
> scenario and his signed-off-by...

I didn't put in a Signed-off-by since Peter didn't give
one, but I did give him credit for the discovery and I
did list explicitly his given logic.
