Return-Path: <linux-kernel-owner+w=401wt.eu-S1759588AbYHSVdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588AbYHSVdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757863AbYHSVdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:33:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755302AbYHSVdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:33:08 -0400
Date: Tue, 19 Aug 2008 14:33:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
In-Reply-To: <20080819.142735.179034162.davem@davemloft.net>
Message-ID: <alpine.LFD.1.10.0808191432040.3324@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808191341150.3324@nehalem.linux-foundation.org> <20080819.140458.236030589.davem@davemloft.net> <alpine.LFD.1.10.0808191411390.3324@nehalem.linux-foundation.org> <20080819.142735.179034162.davem@davemloft.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Aug 2008, David Miller wrote:
> 
> Check the regression list entry you were pointed to in another
> reply.

I did. You apparently didn't do that yourself.

> We enabled GSO segmentation offload [ .. ]

yeah. And look at when that happened.

Dammit, all I ask is that you 

 - admit that you have a problem
 - work on fixing it.

Stop the incessant excuses already.

		Linus
