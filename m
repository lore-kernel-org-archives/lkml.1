Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbYDJDfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbYDJDfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 23:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbYDJDew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 23:34:52 -0400
Received: from ozlabs.org ([203.10.76.45]:44652 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbYDJDew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 23:34:52 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch 09/17] Add all cpus option to stop machine run
Date: Thu, 10 Apr 2008 13:34:32 +1000
User-Agent: KMail/1.9.9
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Adrian Bunk <bunk@stusta.de>, Christoph Hellwig <hch@infradead.org>,
       akpm@osdl.org
References: <20080409150829.855195878@polymtl.ca> <20080409181010.GA4924@martell.zuzino.mipt.ru> <20080409182454.GF30885@one.firstfloor.org>
In-Reply-To: <20080409182454.GF30885@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804101334.32977.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 April 2008 04:24:54 Andi Kleen wrote:
> On Wed, Apr 09, 2008 at 10:10:10PM +0400, Alexey Dobriyan wrote:
> > I continue to think that all this so-called "immediate" infrastructure
> > is an absolute overkill and declared D-cache line savings will _never_
> > matter
>
> You are quite wrong on that.

Well, Alexey did make me read through the patches reasonably thoroughly.

I think it's interesting, and to be honest the current simplified approach 
just isn't that scary.  There are some minor warts, but it's generally sound.

Cheers,
Rusty.
