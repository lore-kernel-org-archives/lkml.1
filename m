Return-Path: <linux-kernel-owner+w=401wt.eu-S1759927AbZD0UAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927AbZD0UAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759112AbZD0UAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:00:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759357AbZD0UAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:00:17 -0400
Date: Mon, 27 Apr 2009 12:48:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Stephen Hemminger <shemminger@vyatta.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       Jarek Poplawski <jarkao2@gmail.com>, Paul Mackerras <paulus@samba.org>,
       paulmck@linux.vnet.ibm.com, Evgeniy Polyakov <zbr@ioremap.net>,
       kaber@trash.net, jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-CPU r**ursive lock {XV}
In-Reply-To: <alpine.LFD.2.00.0904271219570.22156@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904271248130.22156@localhost.localdomain>
References: <20090423210938.1501507b@nehalam> <49F146FF.5050200@cosmosbay.com> <20090424091839.6e13ebec@nehalam> <49F22465.80305@gmail.com> <20090425133052.4cb711f5@nehalam> <49F4A6E3.7080102@cosmosbay.com> <20090426185646.GB29238@Krystal>
 <20090426145746.1184aeba@nehalam> <1240854297.7620.65.camel@twins> <20090427113010.5e3f1700@nehalam> <20090427185423.GC23862@elte.hu> <20090427120658.35a858bb@nehalam> <alpine.LFD.2.00.0904271219570.22156@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 27 Apr 2009, Linus Torvalds wrote:
> 
> Clue bat #1:
> 
> Clue bat #2:
> 
> Clue bat #3:
> 
> Clue bat #3:

Note to self: learn to count beyond three one of these days.

		Linus
