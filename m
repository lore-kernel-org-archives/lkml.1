Return-Path: <linux-kernel-owner+w=401wt.eu-S1761308AbXGWQJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761308AbXGWQJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764456AbXGWQII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:08:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55620 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764405AbXGWQIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:08:06 -0400
Date: Mon, 23 Jul 2007 09:54:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: ericvh@gmail.com, rminnich@lanl.gov, lucho@ionkov.net,
       v9fs-developer@lists.sourceforge.net
Subject: Plan 9 Resource Sharing Support - what is it?
Message-ID: <20070723075434.GA9162@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

  Plan 9 Resource Sharing Support (9P2000) (Experimental) (NET_9P)
[N/m/y/?] (NEW) ?

If you say Y here, you will get experimental support for
Plan 9 resource sharing via the 9P2000 protocol.

See <http://v9fs.sf.net> for more information.

If unsure, say N.

What is "plan 9 resource sharing"? Some kind of mosix-like process
migration? Could you explain it in two lines in Kconfig?

http://v9fs.sf.net

is redirect to 

http://v9fs.sourceforge.net/

which tells me 

Moved to SWiK

after clicking on that, I get to page with content, but no
explanation (could Kconfig/MAINTAINERS be updated?).
 								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
