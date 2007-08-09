Return-Path: <linux-kernel-owner+w=401wt.eu-S940735AbXHIQJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940735AbXHIQJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965235AbXHIQHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:07:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49303 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965948AbXHIQHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:07:40 -0400
Date: Thu, 9 Aug 2007 17:06:49 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de, heiko.carstens@de.ibm.com,
       davem@davemloft.net, schwidefsky@de.ibm.com, wensong@linux-vs.org,
       horms@verge.net.au, wjiang@resilience.com, cfriesen@nortel.com,
       zlynx@acm.org, rpjday@mindspring.com, jesper.juhl@gmail.com
Subject: Re: [PATCH 2/24] make atomic_read() behave consistently on arm
Message-ID: <20070809160649.GA16405@flint.arm.linux.org.uk>
Mail-Followup-To: Chris Snook <csnook@redhat.com>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	torvalds@linux-foundation.org, netdev@vger.kernel.org,
	akpm@linux-foundation.org, ak@suse.de, heiko.carstens@de.ibm.com,
	davem@davemloft.net, schwidefsky@de.ibm.com, wensong@linux-vs.org,
	horms@verge.net.au, wjiang@resilience.com, cfriesen@nortel.com,
	zlynx@acm.org, rpjday@mindspring.com, jesper.juhl@gmail.com
References: <20070809133028.GA13241@shell.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809133028.GA13241@shell.boston.redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 09:30:28AM -0400, Chris Snook wrote:
> From: Chris Snook <csnook@redhat.com>
> 
> Purify volatile use for atomic_t on arm.
> 
> Signed-off-by: Chris Snook <csnook@redhat.com>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
