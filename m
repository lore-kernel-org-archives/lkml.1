Return-Path: <linux-kernel-owner+w=401wt.eu-S1761446AbXGVSOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446AbXGVSOG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 14:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757601AbXGVSNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 14:13:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56121 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755832AbXGVSNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 14:13:53 -0400
Date: Sun, 22 Jul 2007 11:13:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23
In-Reply-To: <200707220535.05527.lenb@kernel.org>
Message-ID: <alpine.LFD.0.999.0707221104420.3607@woody.linux-foundation.org>
References: <200707220535.05527.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 Jul 2007, Len Brown wrote:
> 
> please pull from: 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

Pulled.

Btw, on a mostly unrelated note (and to balance the fact that mostly I 
only speak up to complain), I'd like to say how much I appreciate that not 
only are your git tree histories now clean and readable and don't have 
unnecessary merges, but the use of clear "topic branches" really makes it 
very pleasant to read and see what changed.

I'm certainly hoping the topic branches make your life easier too (ie able 
to track things by topic rather than having changes mixed up), but even if 
it doesn't, I wanted to say that I appreciate how it makes it easier for 
outsiders to follow the "big outline" of your development tree.

So I just wanted to say that I appreciate how it's nice to do "gitk 
ORIG_HEAD.." and see the outline of what has been going on in the ACPI 
tree after I have pulled. And I'm hoping it actually helps you guys too, 
but it's appreciated regardless.

See? Sometimes I can say nice things too.

			Linus "not _always_ grouchy" Torvalds
