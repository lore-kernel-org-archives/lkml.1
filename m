Return-Path: <linux-kernel-owner+w=401wt.eu-S1757179AbYFAItT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbYFAItT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 04:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbYFAIsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 04:48:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754113AbYFAIst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 04:48:49 -0400
Date: Sun, 1 Jun 2008 01:48:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k libc5 regression
Message-Id: <20080601014824.528173bb.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0806011035420.5559@anakin>
References: <Pine.LNX.4.64.0805262226280.11902@anakin>
	<Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz>
	<20080601005338.3affe880.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0806011035420.5559@anakin>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008 10:37:59 +0200 (CEST) Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> > I shall merge this fix into my tree (y'know - the one where memory
> > management patches are hosted) and I'll get it into 2.6.26 and shall
> > offer it to the -stable team.  This will cause me to get collisions
> > with the duplicated patch in linux-next but fortunately it is small. 
> > This time.
> 
> So what's the appropriate way to handle this?

Well at least please reply letting people know what's happening with it.

Ask me to merge it and remind me that it's needed in -stable.  Or just
send the thing to Linus and -stable immediately.  Copy me and I'll do
the usual merge-it-in-case-linus-misses-it trick.

> I should have kept it in the m68k series after NEXT_PATCHES_END, so
> nobody sees it exists?

That would work, as long as we know that the patch is firmly on the
mainline and -stable paths.
