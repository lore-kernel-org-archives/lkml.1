Return-Path: <linux-kernel-owner+w=401wt.eu-S934195AbYD3WWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934195AbYD3WWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761619AbYD3WW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:22:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47837
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760603AbYD3WW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:22:29 -0400
Date: Wed, 30 Apr 2008 15:22:27 -0700 (PDT)
Message-Id: <20080430.152227.23100100.davem@davemloft.net>
To: mingo@elte.hu
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080430221936.GA27292@elte.hu>
References: <20080430135405.ddc42075.akpm@linux-foundation.org>
	<20080430.142137.236846072.davem@davemloft.net>
	<20080430221936.GA27292@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 1 May 2008 00:19:36 +0200

> The same goes in the other direction as well - you were just hit by 
> scheduler tree related regressions that were only triggered on your 
> 128-way sparc64, but not on our 64way x86 and smaller boxes.

You keep saying this over and over again, but the powerpc folks hit
this stuff too.
