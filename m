Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbYHEE6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbYHEE6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 00:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYHEE6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 00:58:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752856AbYHEE6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 00:58:10 -0400
Date: Mon, 4 Aug 2008 21:57:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Switching TestSetPageLocked to trylock_page
In-Reply-To: <200808051444.19738.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.1.10.0808042157020.3299@nehalem.linux-foundation.org>
References: <200807311726.51816.nickpiggin@yahoo.com.au> <20080804205754.b05c8aa9.akpm@linux-foundation.org> <alpine.LFD.1.10.0808042131590.3299@nehalem.linux-foundation.org> <200808051444.19738.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Aug 2008, Nick Piggin wrote:
> 
> Buffer trylock too? Pretty please ;)

Now you're just pushing your luck.

But yeah, I took that one too.

		Linus
