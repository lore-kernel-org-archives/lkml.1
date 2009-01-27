Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbZA0I7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbZA0I7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 03:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbZA0I7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 03:59:42 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54194 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZA0I7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 03:59:41 -0500
Date: Tue, 27 Jan 2009 08:59:40 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: VFS patch queue
Message-ID: <20090127085940.GY28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Unfortunately, the promised third pile of VFS patches didn't
materialize anywhere near the end of merge window - I'd been sick ;-/

	It's obviously too late for pushing that stuff now, so in the
next few days I'm going to go through that + patches that had shown
up since then and push minimal fixes.  The rest will go into the tree
for the next merge cycle and hopefully I'll manage to keep it public
and reasonably up to date.

	I think I got l-k mailbox to more or less managable size without
losing the relevant mail, but in case something critical might be missing in
from the next push, I'd ask folks to check and resend once I post the
pull request.  Actually, I won't mind resends right now - spotting
duplicates won't be a problem.

	Again, my apologies to everybody for disappearing - the timing
really sucked ;-/
