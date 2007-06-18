Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbXFRB7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbXFRB7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 21:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbXFRB7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 21:59:33 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:49534 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbXFRB7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 21:59:33 -0400
Date: Mon, 18 Jun 2007 10:58:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH] clarify the GPL version of contributions by Jesper Juhl in CREDITS
Message-ID: <20070618015801.GA30892@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jesper Juhl <jesper.juhl@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	trivial@kernel.org
References: <200706180233.02955.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706180233.02955.jesper.juhl@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 02:33:02AM +0200, Jesper Juhl wrote:
> Just to make things clear in the light of recent discussions. 
> Stuff I contribute to the Linux kernel are licensed under the terms of the 
> GPL version 2.
> 
> +D: All contributions are licensed under the terms of the GPL version 2.

I suspect this is the default for the vast majority of kernel developers.
Perhaps it's only worth special casing those that have an interest in
GPLv3, as the numbers are bound to be far lower -- if this sort of thing
is judged to be a good idea, that is (It's rather interesting to note
that the vast majority of GPLv3 advocates don't even have a single
changeset in the kernel, yet still feel that their input on kernel
licensing is somehow relevant or valid).
