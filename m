Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbXEACpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbXEACpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 22:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbXEACpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 22:45:33 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933454AbXEACpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 22:45:06 -0400
Date: Mon, 30 Apr 2007 19:43:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
In-Reply-To: <463698D5.20102@zytor.com>
Message-ID: <alpine.LFD.0.98.0704301940320.3808@woody.linux-foundation.org>
References: <463698D5.20102@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Apr 2007, H. Peter Anvin wrote:
> 
> Does *anyone* care about these anymore?

Doubtful. The Tseng ET4000 cards may have been the gold standard in 1991, 
but I don't think most people even _remember_ them. And if they have them 
in their machines, they probably tend to run a Linux-1.2 kernel, or at 
least not care a lot about graphics (ie they may have an old card in the 
machine just because they need VGA to boot, rather than because they care 
about Tseng).

And compared to Tseng and S3, most of the other cards there are just 
obscure.

			Linus
