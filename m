Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbYA2C53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbYA2C53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 21:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbYA2C5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 21:57:21 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54884 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752410AbYA2C5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 21:57:20 -0500
Date: Mon, 28 Jan 2008 18:57:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: torvalds@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: Pull request: DMA pool updates
Message-Id: <20080128185701.752fe2c8.akpm@linux-foundation.org>
In-Reply-To: <20080129024524.GA20198@parisc-linux.org>
References: <20080129001147.GD31101@parisc-linux.org>
	<20080128170734.3101b6aa.akpm@linux-foundation.org>
	<20080129024524.GA20198@parisc-linux.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 19:45:25 -0700 Matthew Wilcox <matthew@wil.cx> wrote:

> > afaik these patches have been tested by nobody except thyself?
> 
> I've tested them myself, then I sent them to the perf team who ran the
> (4 hour long) benchmark, and they reported success.  As with many patches
> these days, they sank into a pit of indifference.

I like to think that's because everyone is all fired up about bugfixes and
the regression reports.  heh.

It's a simple matter for me to add another git tree, which gets things a
bit more exposure.

>  Perhaps I need to
> take a leaf from my former government's book and sex up my patch
> descriptions a bit.

Well these two pulls came with effectively no description at all.  Put
yourself in Linus's position...

