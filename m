Return-Path: <linux-kernel-owner+w=401wt.eu-S2993006AbXCIGf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993006AbXCIGf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 01:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993003AbXCIGf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 01:35:59 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55724 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993006AbXCIGf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 01:35:58 -0500
Date: Thu, 8 Mar 2007 22:35:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
In-Reply-To: <1173419792.32234.131.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703082233060.10832@woody.linux-foundation.org>
References: <1173419792.32234.131.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Mar 2007, Rusty Russell wrote:
>
> __builtin_types_compatible_p() has been around since gcc 2.95, and we
> don't use it anywhere.  This patch quietly fixes that.

Whee.

Rusty, that's a work of art.

However, I would suggest that you never show it to anybody ever again. I'm 
sure that in fifty years, it will be worth much more. So please keep it 
tightly under wraps, to keep people from gouging their eyes out^W^W^W^W^W^W^W 
make a killing in the art market.

Please.

		Linus
