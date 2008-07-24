Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbYGXD0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbYGXD0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 23:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbYGXD0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 23:26:30 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55964 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751221AbYGXD03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 23:26:29 -0400
Date: Wed, 23 Jul 2008 22:26:28 -0500
From: Jack Steiner <steiner@sgi.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: GRU driver feedback
Message-ID: <20080724032627.GA36603@sgi.com>
References: <20080723141229.GB13247@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723141229.GB13247@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 04:12:30PM +0200, Nick Piggin wrote:
> 
> Hi Jack,
> 
> Some review of the GRU driver. Hope it helps. Some trivial.

Thanks for the feedback. I'm at OLS this week & barely reading email.
I'll go thru the comments as soon as I get home next week & will
respond in detail then.


> 
> - I would put all the driver into a single patch. It's a logical change,
>   and splitting them out is not really logical. Unless for example you
>   start with a minimally functional driver and build more things on it,
>   I don't think there is any point avoiding the one big patch. You have to
>   look at the whole thing to understand it properly anyway really.

I would prefer that, too, but was told by one of the more verbose
kernel developers (who will remain nameless) that I should split the code
into multiple patches to make it easier to review. Oh well.....


More responses to follow....


--- jack

