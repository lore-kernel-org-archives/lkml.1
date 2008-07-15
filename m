Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbYGOWmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbYGOWmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbYGOWmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:42:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:45646 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbYGOWmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:42:24 -0400
Date: Tue, 15 Jul 2008 15:39:10 -0700
From: Greg KH <greg@kroah.com>
To: pageexec@freemail.hu
Cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
Message-ID: <20080715223910.GA6500@kroah.com>
References: <20080715183351.GF8185@mit.edu> <487D249C.19043.1BE04D4D@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487D249C.19043.1BE04D4D@pageexec.freemail.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 10:28:44PM +0200, pageexec@freemail.hu wrote:
> Ted, the discussion is *not* about what the best disclosure policy
> would be for the kernel. the problem i raised was that there's one
> declared policy in Documentation/SecurityBugs (full disclosure) yet
> actual actions are completely different and now Linus even admitted
> it.

Huh?

How does what is described there differ from what Linus said, or the
-stable team has been doing so far?

What specifically are you asking for that is different?

The -stable commits are exactly the same as they are in mainline
(Linus's tree).  Are you upset by the fact that I am not saying, "Hey,
look, here's a bugfix that might be security related and here's how to
reproduce it!" in big flashing letters?

thanks,

greg k-h
