Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814Ab0AIKfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab0AIKfa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 05:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617Ab0AIKfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 05:35:30 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56644 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0AIKf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 05:35:29 -0500
Date: Sat, 9 Jan 2010 11:32:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bart?omiej Zimo? <uzi18@o2.pl>, Andy Walls <awalls@radix.net>,
       Daniel Borkmann <danborkmann@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [suspend/resume] Re: userspace notification from module
Message-ID: <20100109103212.GA1429@ucw.cz>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <6f52f5b81001020756i73fbb137if1af8ac8b306f6ba@mail.gmail.com> <ddef1cf.2c9460e3.4b3f8fd5.c10cd@o2.pl> <201001022201.04281.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001022201.04281.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Just need as fast as possible solution and on the other hand acceptable for kernel sources.
> > Usually programs needs just to disconnect something or set one flag.
> > Even if program will have no time for this it could be enough just to send this precious info.
> 
> Perhaps I don't understand correctly what you're trying to achieve, but at the
> moment suspend is always started from user space, this way or another, and on

At least zaurus (arm) suspends from kernel on battery critical.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
