Return-Path: <linux-kernel-owner+w=401wt.eu-S1764934AbYA2AL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764934AbYA2AL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757214AbYA2ALt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:11:49 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:35461 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbYA2ALs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:11:48 -0500
Date: Mon, 28 Jan 2008 17:11:47 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Pull request: DMA pool updates
Message-ID: <20080129001147.GD31101@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


G'day Linus, mate

Could you pull the dmapool branch of
git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git please?

All the patches have been posted to linux-kernel before, and various
comments (and acks) have been taken into account.

It's a fairly nice performance improvement, so would be good to get in.
It's survived a few hours of *mumble* high-stress database benchmark,
so I have high confidence in its stability.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
