Return-Path: <linux-kernel-owner+w=401wt.eu-S1765974AbXGPWLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765974AbXGPWLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762485AbXGPWLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:11:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35559
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760732AbXGPWK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:10:58 -0400
Date: Mon, 16 Jul 2007 15:09:02 -0700 (PDT)
Message-Id: <20070716.150902.55721400.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       olaf.kirch@oracle.com
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070716215117.GA25097@elte.hu>
References: <20070716.042640.18306462.davem@davemloft.net>
	<alpine.LFD.0.999.0707161425361.20061@woody.linux-foundation.org>
	<20070716215117.GA25097@elte.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 16 Jul 2007 23:51:17 +0200

> i also offered to quickly try any test-version of the fixed patch, so 
> there's a real and deterministic path towards fixing the patch. The 
> regression is obvious and triggers all the time.

For you.
