Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbZERRnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbZERRnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZERRn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:43:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507AbZERRnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:43:25 -0400
Date: Mon, 18 May 2009 10:42:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Mahoney <jeffm@suse.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: Re: [patch 4/4] reiserfs: allow exposing privroot w/ xattrs
 enabled
In-Reply-To: <4A119C75.3030400@suse.com>
Message-ID: <alpine.LFD.2.01.0905181041570.3301@localhost.localdomain>
References: <20090517050200.786752018@suse.com> <20090517050332.566856122@suse.com> <alpine.LFD.2.01.0905171009200.3301@localhost.localdomain> <alpine.LFD.2.01.0905181026560.3301@localhost.localdomain> <4A119C75.3030400@suse.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 May 2009, Jeff Mahoney wrote:
> 
> Sorry, I was in and out all weekend. Don't bother merging it for this
> window. I wanted to make it easy to clean up xattrs that would have been
> left around if a file system that contained xattrs was migrated to a
> kernel without support compiled in, but I'll add that to fsck instead.

Ok, thanks, patch happily forgotten,

		Linus
