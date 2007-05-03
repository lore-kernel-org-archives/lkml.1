Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbXECWPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbXECWPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 18:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbXECWPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 18:15:44 -0400
Received: from mail38.syd.optusnet.com.au ([211.29.133.67]:60088 "EHLO
	mail38.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767447AbXECWOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 18:14:53 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: swap-prefetch: 2.6.22 -mm merge plans
Date: Fri, 4 May 2007 08:14:26 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <20070503155407.GA7536@elte.hu>
In-Reply-To: <20070503155407.GA7536@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705040814.26902.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2007 01:54, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> > - If replying, please be sure to cc the appropriate individuals.
> >   Please also consider rewriting the Subject: to something
> >   appropriate.

> i've reviewed it once again and in the !CONFIG_SWAP_PREFETCH case it's a
> clear NOP, while in the CONFIG_SWAP_PREFETCH=y case all the feedback
> i've seen so far was positive. Time to have this upstream and time for a
> desktop-oriented distro to pick it up.
>
> I think this has been held back way too long. It's .config selectable
> and it is as ready for integration as it ever is going to be. So it's a
> win/win scenario.
>
> Acked-by: Ingo Molnar <mingo@elte.hu>

Thank you very much for code review, ack and support!

-- 
-ck
