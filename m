Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbYJHVfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbYJHVfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 17:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754988AbYJHVfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 17:35:00 -0400
Received: from phunq.net ([64.81.85.152]:57534 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754911AbYJHVe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 17:34:59 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC] Btrfs mainline plans
Date: Wed, 8 Oct 2008 14:33:32 -0700
User-Agent: KMail/1.9.5
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>
References: <1222717460.30627.56.camel@think.oraclecorp.com> <20081005141113.GA6132@us.ibm.com> <20081005150957.GC12047@cs181140183.pp.htv.fi>
In-Reply-To: <20081005150957.GC12047@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810081433.32766.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 October 2008 08:09, Adrian Bunk wrote:
> "accelerate its development and will broaden its developer base" is not 
> about users/testers but about people doing code development.
> 
> For people wanting to try WIP code you don't need it in mainline.

But it saves time for the user, who does not have to run around chasing
links, carefully checking for a kernel match, downloading, patching,
building and installing a single purpose kernel, and bringing it up on
a machine that would probably have only required one click on the new
filesystem option otherwise.  The considerable time thus saved can be
invested profitably in running test cases and filing bug reports.
 
> Stable kernels will anyway usually contain months old code of the
> WIP filesystem that is not usable for testing, so for any meaningful
> testing you will still have to follow the btrfs tree and not mainline.

True, but the trick here is getting started.  It is much easier to
justify the effort of going out and getting the latest patch if one
knows from experience that it basically already works.

> This is not meant as a statement on the quality of ext4 or btrfs, or any 
> comparison of the development times of ext4 and btrfs, but for ext4 the 
> advantages Andrew thinks would happen with an early btrfs merge do not 
> seem to have happened.

Are you sure about that?  I see 33 messages on linux-ext4 yesterday,
from a broad range of contributors.  Versus eight from a much narrower
range of contributors, Oct 4 a year ago.

There is little question that an early merge helps both developers and
users employ their time more efficiently, once a project is past the
point where we wonder about its value and/or viability.  In my opinion,
Btrfs clearly has both.  Particularly because we need a way to stem the
loss of mindshare to ZFS in the storage space, which is significant at
the moment.  And Btrfs is closest to the finish line in that regard.
It needs all the help it can get.

Regards,

Daniel
