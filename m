Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbYGFUXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbYGFUXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 16:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbYGFUXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 16:23:39 -0400
Received: from r00tworld.com ([212.85.137.21]:35168 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383AbYGFUXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 16:23:39 -0400
X-Greylist: delayed 1049 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jul 2008 16:23:38 EDT
From: pageexec@freemail.hu
To: Greg KH <greg@kroah.com>
Date: Thu, 03 Jul 2008 21:31:45 +0200
MIME-Version: 1.0
Subject: Re: Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Message-ID: <486D4541.25808.C600354@pageexec.freemail.hu>
In-reply-to: <20080703185727.GA12617@suse.de>
References: <20080703035807.GA8190@kroah.com>, <20080703172914.GA11123@suse.de>, <20080703185727.GA12617@suse.de>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Thu, 03 Jul 2008 21:32:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[spender's asked to be off the CC]

On 3 Jul 2008 at 11:57, Greg KH wrote:

> On Thu, Jul 03, 2008 at 10:29:14AM -0700, Greg KH wrote:
> Adding 2 more addresses to this thread, as they were said to have
> questions about this kernel release.

not only this one, but every commit for the past few years that fixed
bugs with security impact. for reference:

http://lwn.net/Articles/285438/
http://lwn.net/Articles/286263/
http://lwn.net/Articles/287339/
http://lwn.net/Articles/288473/

> Again, if the above information is somehow insufficient as to what
> exactly is fixed in the -stable releases, and anyone has questions about
> how these release announcements are created, please let me know.

what is the disclosure policy used for commits fixing bugs with security
impact (both vanilla and -stable, especially if there's a difference)?

what do you include/omit?

how does it relate to what is declared in Documentation/SecurityBugs?

