Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbXLLTY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbXLLTY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758242AbXLLTYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:24:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52435
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757398AbXLLTYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:24:43 -0500
Date: Wed, 12 Dec 2007 11:24:43 -0800 (PST)
Message-Id: <20071212.112443.161687571.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: kjwinchester@gmail.com, mingo@elte.hu, per.liden@ericsson.com,
       jon.maloy@ericsson.com, allan.stephens@windriver.com,
       tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [patch 1/1] Convert the semaphore to a mutex in
 net/tipc/socket.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071211164445.752431ec.akpm@linux-foundation.org>
References: <20071210011741.039692330@gmail.com>
	<20071210011800.543055487@gmail.com>
	<20071211164445.752431ec.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 11 Dec 2007 16:44:45 -0800

> So I'd propose this:

I've applied this to net-2.6, thanks Andrew.
