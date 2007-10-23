Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbXJWWlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbXJWWlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbXJWWiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:38:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49480
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754538AbXJWWiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:38:09 -0400
Date: Tue, 23 Oct 2007 15:38:36 -0700 (PDT)
Message-Id: <20071023.153836.85407923.davem@davemloft.net>
To: jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 11/12] NET: fix subqueue bugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071023223646.550241F81B7@havoc.gtf.org>
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
	<20071023223646.550241F81B7@havoc.gtf.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Tue, 23 Oct 2007 18:36:46 -0400 (EDT)

> net/sched/sch_prio.c: In function $,1rx(Bprio_dequeue$,1ry(B:
> net/sched/sch_prio.c:139: warning: passing argument 2 of $,1rx(Bnetif_subqueue_stopped$,1ry(B makes pointer from integer without a cast
> net/sched/sch_prio.c: In function $,1rx(Brr_dequeue$,1ry(B:
> net/sched/sch_prio.c:169: warning: passing argument 2 of $,1rx(Bnetif_subqueue_stopped$,1ry(B makes pointer from integer without a cast
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

I have another copy of this from Pavel earlier in my inbox
and I promise I will integrate his patch today :-)
