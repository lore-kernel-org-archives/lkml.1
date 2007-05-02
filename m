Return-Path: <linux-kernel-owner+w=401wt.eu-S1766743AbXEBWbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766743AbXEBWbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766739AbXEBWbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:31:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:35893 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766735AbXEBWbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:31:46 -0400
Subject: Re: incoming
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Christoph Lameter <clameter@engr.sgi.com>,
       "David S. Miller" <davem@davemloft.net>, Andi Kleen <ak@suse.de>,
       "Luck, Tony" <tony.luck@intel.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20070502150252.7ddf67ac.akpm@linux-foundation.org>
References: <20070502150252.7ddf67ac.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 03 May 2007 08:31:14 +1000
Message-Id: <1178145074.17299.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-02 at 15:02 -0700, Andrew Morton wrote:
> So this is what I have lined up for the first mm->2.6.22 batch.  I won't be
> sending it off for another 12-24 hours yet.  To give people time for final
> comment and to give me time to see if it actually works.

Thanks.

I have some powerpc bits that depend on that stuff that will go through
Paulus after these show up in git and I've rebased.

Cheers,
Ben.


