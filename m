Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbZJFXyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbZJFXyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 19:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758473AbZJFXyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 19:54:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:39340 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758415AbZJFXyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 19:54:12 -0400
Message-ID: <4ACBD841.1080109@kernel.org>
Date: Wed, 07 Oct 2009 08:52:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: cl@linux-foundation.org
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V5 01/19] Introduce this_cpu_ptr() and generic this_cpu_*
 operations
References: <20091006233654.815079668@gentwo.org> <20091006233729.711197725@gentwo.org>
In-Reply-To: <20091006233729.711197725@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 06 Oct 2009 23:52:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cl@linux-foundation.org wrote:
> This patch introduces two things: First this_cpu_ptr and then per cpu
> atomic operations.

percpu#for-next is for the most part a stable tree and 1-12 are
already in the tree.  Can you please send the changes based on the
current percpu#for-next?

Thanks.

-- 
tejun
