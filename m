Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYAVPxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYAVPxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 10:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYAVPxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 10:53:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49531 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276AbYAVPxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 10:53:31 -0500
Date: Tue, 22 Jan 2008 07:53:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 0/6] RFC: Typesafe callbacks
In-Reply-To: <200801221816.19594.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.1.00.0801220751180.2957@woody.linux-foundation.org>
References: <200801202046.14746.rusty@rustcorp.com.au> <200801221027.15002.rusty@rustcorp.com.au> <alpine.LFD.1.00.0801211547160.2957@woody.linux-foundation.org> <200801221816.19594.rusty@rustcorp.com.au>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Jan 2008, Rusty Russell wrote:
> 
>     If we can stomach it the effect is nice, but the version which simply 
> allows pointer correctness (rather than trying to do unsigned long too) is 
> less bletcherous.

I'd suggest trying to get by with just the pointer version for now. But we 
know whom to turn to when we need bletcherousness.

		Linus
