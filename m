Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbYHBUFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbYHBUFV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 16:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbYHBUFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 16:05:10 -0400
Received: from 1wt.eu ([62.212.114.60]:2373 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546AbYHBUFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 16:05:09 -0400
Date: Sat, 2 Aug 2008 22:04:49 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oliver Pinter <oliver.pntr@gmail.com>,
       Abdel Benamrouche <draconux@gmail.com>, stable@kernel.org,
       jens.axboe@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC, 2.6.26.2-rc1]  fs/partition/check.c: fix return value warning
Message-ID: <20080802200448.GH615@1wt.eu>
References: <200808022202.48079.oliver.pntr@gmail.com> <alpine.LFD.1.10.0808021254190.3874@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808021254190.3874@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2008 at 12:56:10PM -0700, Linus Torvalds wrote:
> Please don't just send patches to the stable team because they "look 
> fine". They should be real bugs, with real consequences. And no, a 
> compiler warning is not a real consequence.

BTW, before Oliver does the mistake, I'd suggest never forwarding
network patches to stable either as Davem already maintains his
own -stable queue ;-)

Willy

