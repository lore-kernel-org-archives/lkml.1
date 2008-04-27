Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbYD0Gcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbYD0Gcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 02:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbYD0Gcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 02:32:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54048
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752946AbYD0Gcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 02:32:41 -0400
Date: Sat, 26 Apr 2008 23:32:40 -0700 (PDT)
Message-Id: <20080426.233240.252075490.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: [patch] ftrace, v15
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080427063019.GA23295@elte.hu>
References: <20080427063019.GA23295@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 27 Apr 2008 08:30:19 +0200

>       sched: fix rq->clock overflows detection with CONFIG_NO_HZ
>       sched: make sure jiffies is up to date before calling __update_rq_clock()

You're getting sloppier and sloppier each and every bogus pull request
you send out this week Ingo.

What is all of this non-ftrace crap in the shortlog?

