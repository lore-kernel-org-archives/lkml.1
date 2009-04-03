Return-Path: <linux-kernel-owner+w=401wt.eu-S934839AbZDCPSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934839AbZDCPSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932864AbZDCPSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:18:15 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:59958 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933556AbZDCPSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:18:13 -0400
Date: Fri, 3 Apr 2009 11:18:12 -0400
To: Mark Lord <lkml@rtr.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Janne Grunau <j@jannau.net>,
       Theodore Tso <tytso@mit.edu>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090403151812.GK3795@csclub.uwaterloo.ca>
References: <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402110532.GA5132@aniel> <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com> <20090402094247.9d7ac19f.akpm@linux-foundation.org> <alpine.LFD.2.00.0904020947310.4130@localhost.localdomain> <alpine.LFD.2.00.0904020959490.4130@localhost.localdomain> <49D627DF.6090501@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D627DF.6090501@rtr.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 11:14:39AM -0400, Mark Lord wrote:
> Note that for mythtv, this may not be the best behaviour.
>
> A common use scenario is "watching live TV", a few minutes behind
> real-time so that the commercial-skipping can work its magic.

Well I really never watch live TV.  I watch shows when I want to, not
when they happen to be on the air.  So I certainly couldn't care less
if they were no longer cached.

> In that scenario, those pages are going to be needed again
> within a short while, and it might be useful to keep them around.

Within 1 minute might be a lot of data for an MPEG2 stream.

> But then Myth itself could probably decide whether to discard them
> or not, not based upon that kind of knowledge.

-- 
Len Sorensen
