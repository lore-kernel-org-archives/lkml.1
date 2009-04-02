Return-Path: <linux-kernel-owner+w=401wt.eu-S1763252AbZDBVyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763252AbZDBVyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757312AbZDBVyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:54:44 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:39805 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756905AbZDBVyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:54:43 -0400
Date: Thu, 2 Apr 2009 17:54:42 -0400
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090402215442.GC3795@csclub.uwaterloo.ca>
References: <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402121735.GD10642@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402121735.GD10642@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 08:17:35AM -0400, Theodore Tso wrote:
> Well, ext4 will be an interim solution you can convert to first.  It
> will be best with a backup/reformat/restore pass, better if you enable
> extents (at least for new files, but then you won't be able to go back
> to ext3), but you'll get improvements even if you just mount an ext3
> filesystem as ext4.

Well I did pickup a 1TB external USB/eSATA drive for pretty much such
a task.  I wasn't sure if ext4 was ready or stable enough to play
with yet though.

-- 
Len Sorensen
