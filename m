Return-Path: <linux-kernel-owner+w=401wt.eu-S934495AbXHJLFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934495AbXHJLFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 07:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbXHJLFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 07:05:13 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:43749 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbXHJLFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 07:05:11 -0400
Date: Thu, 9 Aug 2007 21:09:27 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de, heiko.carstens@de.ibm.com,
       davem@davemloft.net, schwidefsky@de.ibm.com, wensong@linux-vs.org,
       horms@verge.net.au, wjiang@resilience.com, cfriesen@nortel.com,
       zlynx@acm.org, rpjday@mindspring.com, jesper.juhl@gmail.com
Subject: Re: [PATCH 13/24] make atomic_read() behave consistently on mips
Message-ID: <20070809200927.GA17855@linux-mips.org>
References: <20070809140004.GA17112@shell.boston.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809140004.GA17112@shell.boston.redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 10:00:04AM -0400, Chris Snook wrote:

> Purify volatile use for atomic[64]_t on mips.
> 
> Signed-off-by: Chris Snook <csnook@redhat.com>

Acked-by: Ralf Baechle <ralf@linux-mips.org>
