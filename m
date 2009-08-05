Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbZHEPh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbZHEPh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbZHEPh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:37:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39334
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755809AbZHEPhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:37:24 -0400
Date: Wed, 05 Aug 2009 08:37:33 -0700 (PDT)
Message-Id: <20090805.083733.81430600.davem@davemloft.net>
To: jpirko@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Fix spinlock use in alloc_netdev_mq()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090805084746.GA3897@psychotron.englab.brq.redhat.com>
References: <20090805071411.GA9217@elte.hu>
	<20090805071658.GA14073@elte.hu>
	<20090805084746.GA3897@psychotron.englab.brq.redhat.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jpirko@redhat.com>
Date: Wed, 5 Aug 2009 10:47:47 +0200

>>Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Acked-by: Jiri Pirko <jpirko@redhat.com>

Applied, thanks everyone.
