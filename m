Return-Path: <linux-kernel-owner+w=401wt.eu-S965563AbXIBLi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965563AbXIBLi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 07:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965020AbXIBLiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 07:38:11 -0400
Received: from stinky.trash.net ([213.144.137.162]:47037 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964963AbXIBLiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 07:38:09 -0400
Message-ID: <46DAA048.3090709@trash.net>
Date: Sun, 02 Sep 2007 13:36:40 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH -mm] net/sched/sch_cbq.c: Shut up uninitialized variable
 warning
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <alpine.LFD.0.999.0709020656050.20781@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0709020656050.20781@enigma.security.iitk.ac.in>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> net/sched/sch_cbq.c: In function 'cbq_enqueue':
> net/sched/sch_cbq.c:383: warning: 'ret' may be used uninitialized in this function
>
> has been verified to be a bogus case. So let's shut it up.
>
> Signed-off-by: Satyam Sharma <satyam@infradead.org>

Acked-by: Patrick McHardy <kaber@trash.net>

