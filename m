Return-Path: <linux-kernel-owner+w=401wt.eu-S1757996AbYEOKZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbYEOKZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 06:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbYEOKZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 06:25:46 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:55075 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbYEOKZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 06:25:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=un+y6b4KdqiXeaiv3YINVNDAmdpzbMLC7T/7Xm4QLqy67Gfkzo2VSC0I5UJ63KLRcyb15R15qDmEPPv2ZB9eUKnNyRdbI55NJR3iu3w3myrgnN4RyEUfAZveXNbuA+fORdmw0MrhJVT8ucGUx/D1We1cdp2OyYKrfOqFxMyGfnc=
Date: Thu, 15 May 2008 10:29:13 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Kingsley Foreman <kingsley@internode.com.au>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NET_SCHED cbq dropping too many packets on a bonding interface
Message-ID: <20080515102913.GA6753@ff.dom.local>
References: <20080515091216.GA6550@ff.dom.local> <8ECDBB4EB5394859BFFACAAEE3A6EDB0@uglypunk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ECDBB4EB5394859BFFACAAEE3A6EDB0@uglypunk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 07:36:54PM +0930, Kingsley Foreman wrote:
...
> i just rolled back the kernel to 2.6.24 and im seeing the same thing,
>
> I was using 2.6.22 before and didn't see the problem, txqueuelen on the  
> bond0 interface is 0 (the default)

So, could you try if the size matters here...?

Jarek P.
