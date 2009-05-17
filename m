Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZEQRK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZEQRK4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 13:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbZEQRKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 13:10:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752934AbZEQRKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 13:10:44 -0400
Date: Sun, 17 May 2009 10:10:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Mahoney <jeffm@suse.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: Re: [patch 4/4] reiserfs: allow exposing privroot w/ xattrs
 enabled
In-Reply-To: <20090517050332.566856122@suse.com>
Message-ID: <alpine.LFD.2.01.0905171009200.3301@localhost.localdomain>
References: <20090517050200.786752018@suse.com> <20090517050332.566856122@suse.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 17 May 2009, Jeff Mahoney wrote:
>
> --- a/fs/reiserfs/dir.c
> +++ b/fs/reiserfs/dir.c

Hmm. This had no explanation or sign-off. Please? At least the sign-off, 
but I think I'd like a log message too, since this adds a new mount option 
etc, so it's not like this is some trivial one-liner that doesn't need it.

		Linus
