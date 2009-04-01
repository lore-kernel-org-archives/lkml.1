Return-Path: <linux-kernel-owner+w=401wt.eu-S1764967AbZDAVDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764967AbZDAVDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 17:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbZDAVDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 17:03:41 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:34946 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480AbZDAVDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 17:03:40 -0400
Date: Wed, 1 Apr 2009 17:03:38 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090401210337.GB3797@csclub.uwaterloo.ca>
References: <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com> <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326182519.d576d703.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 06:25:19PM -0700, Andrew Morton wrote:
> The JBD journal is a massive designed-in contention point.  It's why
> for several years I've been telling anyone who will listen that we need
> a new fs.  Hopefully our response to all these problems will soon be
> "did you try btrfs?".

Oh I look forward to the day when it will be safe to convert my mythtv
box from ext3 to btrfs.  Current kernels just have too much IO latency
with ext3 it seems.  Older kernels were more responsive, but probably
had other places they were less efficient.

-- 
Len Sorensen
