Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbZDVKNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbZDVKNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 06:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbZDVKNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 06:13:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:56473 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbZDVKNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 06:13:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=E2j1DTJITMP3pgm23QfiCuGxK0K2J93Wv0hVkCqMcAO/Rwhk4zxuEkFhL/pBW18TQ0
         l2xfD/WhuoMj8KFMd/j3FR7w6MavUJ1pYu8dJwwCsNEMYt/Dgzt26hz0ZEVd7IeS8Eu3
         ziNwTWjtA+nzwcDhV7Qsc8Hrfnubzzs2RVHaw=
Date: Wed, 22 Apr 2009 10:13:18 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Hemminger <shemminger@vyatta.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, paulmck@linux.vnet.ibm.com,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       kaber@trash.net, jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu recursive lock (v11)
Message-ID: <20090422101318.GA6630@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EEDAF0.2010507@cosmosbay.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-04-2009 10:53, Eric Dumazet wrote:
...
> If this could be done without recursion, I am pretty sure netfilter
> and network guys would have done it. I found Linus reaction quite
> shocking IMHO, considering hard work done by all people on this.

Right, looks like 100% (Scandinavian?!) troll. I wonder where is the
admin of this mess...

Jarek P.
