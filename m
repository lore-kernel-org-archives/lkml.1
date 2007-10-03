Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbXJCHMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbXJCHMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 03:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbXJCHMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 03:12:46 -0400
Received: from mx10.go2.pl ([193.17.41.74]:51555 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753130AbXJCHMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 03:12:46 -0400
Date: Wed, 3 Oct 2007 09:15:19 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: davids@webmaster.com
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
Message-ID: <20071003071519.GA1726@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKCEEEHDAC.davids@webmaster.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02-10-2007 17:37, David Schwartz wrote:
...
> So now I not only have to come up with an example where sched_yield is the
> best practical choice, I have to come up with one where sched_yield is the
> best conceivable choice? Didn't we start out by agreeing these are very rare
> cases? Why are we designing new APIs for them (Arjan) and why do we care
> about their performance (Ingo)?
> 
> These are *rare* cases. It is a waste of time to optimize them.

Probably we'll start to care after first comparison tests done by our
rivals. It should be a piece of cake for them to find the "right"
code...

Regards,
Jarek P.
