Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbXECH4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbXECH4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 03:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbXECH4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 03:56:14 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2717 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231AbXECH4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 03:56:13 -0400
Date: Thu, 3 May 2007 08:55:43 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Christoph Lameter <clameter@engr.sgi.com>,
       "David S. Miller" <davem@davemloft.net>, Andi Kleen <ak@suse.de>,
       "Luck, Tony" <tony.luck@intel.com>, Rik van Riel <riel@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: incoming
Message-ID: <20070503075543.GA12018@flint.arm.linux.org.uk>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Hugh Dickins <hugh@veritas.com>,
	Christoph Lameter <clameter@engr.sgi.com>,
	"David S. Miller" <davem@davemloft.net>, Andi Kleen <ak@suse.de>,
	"Luck, Tony" <tony.luck@intel.com>, Rik van Riel <riel@redhat.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20070502150252.7ddf67ac.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502150252.7ddf67ac.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 03:02:52PM -0700, Andrew Morton wrote:
> So this is what I have lined up for the first mm->2.6.22 batch.  I won't be
> sending it off for another 12-24 hours yet.  To give people time for final
> comment and to give me time to see if it actually works.

I assume you're going to update this list with my comments I sent
yesterday?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
