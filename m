Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbYHRCD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbYHRCD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 22:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbYHRCDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 22:03:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56090
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751291AbYHRCDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 22:03:48 -0400
Date: Sun, 17 Aug 2008 19:03:48 -0700 (PDT)
Message-Id: <20080817.190348.73384265.davem@davemloft.net>
To: michael@ellerman.id.au
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: bug in lmb_enforce_memory_limit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1219024832.8115.4.camel@localhost>
References: <1218847582.7576.6.camel@localhost>
	<20080815.195724.238982506.davem@davemloft.net>
	<1219024832.8115.4.camel@localhost>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ellerman <michael@ellerman.id.au>
Date: Mon, 18 Aug 2008 12:00:32 +1000

> Although I can't find a system with holes (the newer hypervisors make
> things look contiguous I think), so I can't really test the interesting
> case.

I have several so I'll make sure it works in such cases :)
