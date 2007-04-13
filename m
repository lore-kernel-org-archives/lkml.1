Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbXDMNVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbXDMNVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbXDMNVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:21:55 -0400
Received: from holomorphy.com ([66.93.40.71]:36734 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbXDMNVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:21:54 -0400
Date: Fri, 13 Apr 2007 06:22:00 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <npiggin@suse.de>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] generic rwsems
Message-ID: <20070413132200.GT2986@holomorphy.com>
References: <20070413100416.GC31487@wotan.suse.de> <25821.1176466182@redhat.com> <20070413124303.GD966@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413124303.GD966@wotan.suse.de>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 02:43:03PM +0200, Nick Piggin wrote:
> Yes, this is the case on our 2 premiere SMP powerhouse architectures,
> sparc32 and parsic.

sparc32 is ultra-legacy and I have a tremendous amount of work to do on
SMP there. I don't feel that efficiency of locking primitives is a
crucial issue for sparc32.


-- wli
