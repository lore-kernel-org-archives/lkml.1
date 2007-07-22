Return-Path: <linux-kernel-owner+w=401wt.eu-S1763952AbXGVTZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763952AbXGVTZP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 15:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762318AbXGVTY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 15:24:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:44697 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759983AbXGVTY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 15:24:58 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23
Date: Sun, 22 Jul 2007 15:24:52 -0400
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200707220535.05527.lenb@kernel.org> <alpine.LFD.0.999.0707221104420.3607@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707221104420.3607@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707221524.53177.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 July 2007 14:13, Linus Torvalds wrote:
> 
> On Sun, 22 Jul 2007, Len Brown wrote:
> > 
> > please pull from: 
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> 
> Pulled.
> 
> Btw, on a mostly unrelated note (and to balance the fact that mostly I 
> only speak up to complain), I'd like to say how much I appreciate that not 
> only are your git tree histories now clean and readable and don't have 
> unnecessary merges, but the use of clear "topic branches" really makes it 
> very pleasant to read and see what changed.
> 
> I'm certainly hoping the topic branches make your life easier too (ie able 
> to track things by topic rather than having changes mixed up), but even if 
> it doesn't, I wanted to say that I appreciate how it makes it easier for 
> outsiders to follow the "big outline" of your development tree.
> 
> So I just wanted to say that I appreciate how it's nice to do "gitk 
> ORIG_HEAD.." and see the outline of what has been going on in the ACPI 
> tree after I have pulled. And I'm hoping it actually helps you guys too, 
> but it's appreciated regardless.
> 
> See? Sometimes I can say nice things too.
> 
> 			Linus "not _always_ grouchy" Torvalds


Wow! -- somebody pinch me!:-)

Credit goes to Tony Luck, however.  He's the one who took the trouble
to figure out and document "maintaining-topic-branches" -- now
in git/Documentation/user-manual.txt.  That use-model works well for me.

thanks,
-Len
