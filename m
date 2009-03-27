Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbZC0Vog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbZC0Vog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 17:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758304AbZC0VoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 17:44:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757052AbZC0VoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 17:44:20 -0400
Date: Fri, 27 Mar 2009 14:41:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Roland Dreier <rdreier@cisco.com>
cc: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RDMA/nes: Fix mis-merge
In-Reply-To: <ada4oxeu67q.fsf_-_@cisco.com>
Message-ID: <alpine.LFD.2.00.0903271440400.3994@localhost.localdomain>
References: <20090326.020714.36421849.davem@davemloft.net> <20090326.152515.43533230.davem@davemloft.net> <alpine.LFD.2.00.0903261555290.3032@localhost.localdomain> <adahc1fuarm.fsf_-_@cisco.com> <ada4oxeu67q.fsf_-_@cisco.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Mar 2009, Roland Dreier wrote:
>
> Resending because this seems to have gotten dropped (probably because I

Actually, it didn't get dropped - I just forgot to push out my tree after 
the final fixes yesterday.

		Linus
