Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbZHQQ3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbZHQQ3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 12:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbZHQQ3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 12:29:21 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:59448 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756232AbZHQQ3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 12:29:20 -0400
Date: Mon, 17 Aug 2009 12:29:03 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Ingo Molnar <mingo@elte.hu>, Amerigo Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Thomas Gleixner <tglx@linutronix.de>, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [Patch] proc: drop write permission on 'timer_list' and
 'slabinfo'
In-Reply-To: <1250502847.5038.16.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0908171228300.16267@gentwo.org>
References: <20090817094525.6355.88682.sendpatchset@localhost.localdomain>  <20090817094822.GA17838@elte.hu> <1250502847.5038.16.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009, Pekka Enberg wrote:

> > I have applied the timer_list bits to the timer tree. The SLUB/SLAB
> > bits should go into the SLAB tree i guess.
>
> Yeah, I'll grab the slab parts to slab.git if I don't see a separate
> patch in my inbox when I get home. Thanks!

slab needs the write permissions for tuning!

