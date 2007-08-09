Return-Path: <linux-kernel-owner+w=401wt.eu-S966419AbXHIQpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966419AbXHIQpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966289AbXHIQpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:45:39 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:54526 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966285AbXHIQpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:45:36 -0400
Date: Thu, 9 Aug 2007 12:45:34 -0400
From: Kyle McMartin <kyle@parisc-linux.org>
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de, heiko.carstens@de.ibm.com,
       davem@davemloft.net, schwidefsky@de.ibm.com, wensong@linux-vs.org,
       horms@verge.net.au, wjiang@resilience.com, cfriesen@nortel.com,
       zlynx@acm.org, rpjday@mindspring.com, jesper.juhl@gmail.com
Subject: Re: [PATCH 14/24] make atomic_read() behave consistently on parisc
Message-ID: <20070809164534.GC27558@fattire.cabal.ca>
References: <20070809140154.GA17489@shell.boston.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809140154.GA17489@shell.boston.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 10:01:54AM -0400, Chris Snook wrote:
> From: Chris Snook <csnook@redhat.com>
> 
> Purify volatile use for atomic[64]_t on parisc.
> 
> Signed-off-by: Chris Snook <csnook@redhat.com>
> 

Sure, why not.

ACKed-by: Kyle McMartin <kyle@parisc-linux.org>
