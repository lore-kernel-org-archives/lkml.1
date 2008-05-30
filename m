Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbYE3U5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbYE3U5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 16:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbYE3U5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 16:57:10 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:52109 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbYE3U5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 16:57:09 -0400
Date: Fri, 30 May 2008 20:19:34 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Top kernel oopses/warnings for the week of May 30th 2008
In-Reply-To: <48402DAA.60202@linux.intel.com>
Message-ID: <Pine.LNX.4.64.0805302017580.16427@blonde.site>
References: <48402DAA.60202@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008, Arjan van de Ven wrote:
> 
> Rank 7: set_page_address (oops)
> 	Reported 53 times (65 total reports)
> 	crash coming from flush_all_zero_pkmaps; was this fixed by Hugh the
> 	other day?

No, not at all.  But I'll have a little ponder over it.

> 	This oops was last seen in version 2.6.25.3, and first seen in 2.6.25.
> 	More info:
> 	http://www.kerneloops.org/searchweek.php?search=set_page_address

Hugh
