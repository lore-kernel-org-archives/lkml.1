Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbYHEEcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbYHEEcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 00:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbYHEEcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 00:32:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752767AbYHEEce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 00:32:34 -0400
Date: Mon, 4 Aug 2008 21:32:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Switching TestSetPageLocked to trylock_page
In-Reply-To: <20080804205754.b05c8aa9.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808042131590.3299@nehalem.linux-foundation.org>
References: <200807311726.51816.nickpiggin@yahoo.com.au> <200808051314.33791.nickpiggin@yahoo.com.au> <alpine.LFD.1.10.0808042024480.3299@nehalem.linux-foundation.org> <200808051341.53282.nickpiggin@yahoo.com.au>
 <20080804205754.b05c8aa9.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 4 Aug 2008, Andrew Morton wrote:
> 
> Would prefer either that we hold off until after 2.6.27 is released or
> just do it now.

Ok, I took that as an ack and just applied it.

		Linus
