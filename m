Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbYC0WfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbYC0WfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 18:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbYC0We4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 18:34:56 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:63029 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYC0Wey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 18:34:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=TQ6MPb1ickkI3tDTrIaXIj3oiyTp+W+5i1fyRI3B04RHm4mXeLGujkLy8UxdWdR+UCRgk6EICp42sSGoPQnGMXzi0X9wF4p6PS9pTrlU16MAB+4MmKmLj8/4hIrKln+8TgtixeBHZ/CeYeGzPQIaLojgT8AF4gVc5ralLDIr6oc=
Date: Thu, 27 Mar 2008 23:39:13 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: rjw@sisk.pl, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       netdev@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       marcus@better.se, shemminger@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [Bugme-new] [Bug 10326] New: inconsistent lock state in
	net_rx_action
Message-ID: <20080327223913.GB3596@ami.dom.local>
References: <20080327124928.GE2845@ami.dom.local> <200803272256.50454.rjw@sisk.pl> <20080327222248.GA3596@ami.dom.local> <20080327.152218.235944668.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327.152218.235944668.davem@davemloft.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 03:22:18PM -0700, David Miller wrote:
...
> Instead of going back and forth like this can someone post
> just take it upon themselves to post such an obvious patch
> already :-)
> 
> All of this "he'll do it, she'll do it" just wastes time.

Right! She or he should also remember to add Peter's lockup
scenario and his signed-off-by...

Jarek P.
