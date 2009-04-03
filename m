Return-Path: <linux-kernel-owner+w=401wt.eu-S1759403AbZDCAdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403AbZDCAdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 20:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbZDCAc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 20:32:59 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:52703 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759232AbZDCAc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 20:32:58 -0400
Date: Thu, 2 Apr 2009 20:32:56 -0400
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090403003256.GE3795@csclub.uwaterloo.ca>
References: <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402121735.GD10642@mit.edu> <20090402215442.GC3795@csclub.uwaterloo.ca> <20090402232715.GE9870@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402232715.GE9870@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 07:27:15PM -0400, Theodore Tso wrote:
> To play with, definitely.  For production use, I'll have to let you
> make your own judgements.  I've been using it on my laptop since July.

Well I made a 75GB ext4 just to store temporary virtual machine images
to play with.  I won't be upset if I loose those.

> At the moment, there's only one bug which I'm very concerned about,
> being worked here:
> 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/330824
> 
> But a number of community distro's will be supporting it within the
> next month or two.  So it's definitely getting there.  As we increase
> the user base, we'll turn up more of the harder-to-reproduce bugs, but
> hopefully we'll get them fixed quickly.

Well pretty soon I will probably consider switching to that.  btrfs sounds
neat and all, but I will wait for the disk format to get finalized first.

-- 
Len Sorensen
