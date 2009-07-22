Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbZGVPje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbZGVPje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbZGVPjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:39:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58313
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751768AbZGVPjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:39:32 -0400
Date: Wed, 22 Jul 2009 08:39:38 -0700 (PDT)
Message-Id: <20090722.083938.214269732.davem@davemloft.net>
To: peterz@infradead.org
Cc: torvalds@linux-foundation.org, tglx@linutronix.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kaber@trash.net
Subject: Re: [PATCH] softirq: tasklet_hrtimer
From: David Miller <davem@davemloft.net>
In-Reply-To: <1248265724.27058.1366.camel@twins>
References: <1247832892.15751.35.camel@twins>
	<20090721.201855.32703627.davem@davemloft.net>
	<1248265724.27058.1366.camel@twins>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 22 Jul 2009 14:28:44 +0200

> Thomas, will you take this?
> 
> ---
> Subject: softirq: tasklet_hrtimer
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Wed Jul 22 14:18:35 CEST 2009
> 
> Stick tasklets and hrtimers together to provide an in-softirq hrtimer
> experience.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: David S. Miller <davem@davemloft.net>
