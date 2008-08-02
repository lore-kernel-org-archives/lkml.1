Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYHBIeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYHBIeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 04:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYHBIeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 04:34:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54001
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752173AbYHBIeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 04:34:03 -0400
Date: Sat, 02 Aug 2008 01:34:00 -0700 (PDT)
Message-Id: <20080802.013400.253519655.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: mingo@elte.hu, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] lockdep: re-annotate scheduler runqueues
From: David Miller <davem@davemloft.net>
In-Reply-To: <1217588923.9686.7.camel@twins>
References: <20080801090100.GA25142@elte.hu>
	<20080801.021348.233313767.davem@davemloft.net>
	<1217588923.9686.7.camel@twins>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 01 Aug 2008 13:08:43 +0200

> The thing that triggered it for David is a regular kernel build with
> large concurrency.

Peter, I've been beating up these two patches here for a while
on my 64-cpu box and it hasn't budged yet.

I'll let you know if anything happens, but it looks good so far.
