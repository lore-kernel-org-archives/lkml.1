Return-Path: <linux-kernel-owner+w=401wt.eu-S940763AbXHIOd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940763AbXHIOd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965357AbXHIOdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:33:15 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:62993 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940661AbXHIOdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:33:11 -0400
Subject: Re: [PATCH 16/24] make atomic_read() behave consistently on s390
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de, heiko.carstens@de.ibm.com,
       davem@davemloft.net, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com
In-Reply-To: <20070809140655.GA17731@shell.boston.redhat.com>
References: <20070809140655.GA17731@shell.boston.redhat.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 09 Aug 2007 16:36:48 +0200
Message-Id: <1186670208.9669.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-09 at 10:06 -0400, Chris Snook wrote:
> From: Chris Snook <csnook@redhat.com>
> 
> Make atomic[64]_read() volatile on s390, to ensure memory is actually read
> each time.
> 
> Signed-off-by: Chris Snook <csnook@redhat.com>

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


