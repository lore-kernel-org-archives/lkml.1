Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbYACRJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbYACRJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbYACRJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:09:29 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:41446 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYACRJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:09:28 -0500
Date: Thu, 3 Jan 2008 18:09:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: malattia@linux.it, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, trivial@kernel.org
Subject: Re: struct should not be named same way as function in sony-laptop
Message-ID: <20080103170930.GA1728@elf.ucw.cz>
References: <20080103110154.GA2376@elf.ucw.cz> <20080103111543.GS27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103111543.GS27894@ZenIV.linux.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-01-03 11:15:43, Al Viro wrote:
> On Thu, Jan 03, 2008 at 12:01:54PM +0100, Pavel Machek wrote:
> > Naming struct and function by same name is evil. Rename the struct.
> 
> Um... why?  It's not even particulary bad style per se...  Occurs less
> frequently than things like
> 	struct foo *foo;
> but nothing inherently terrible and not likely to cause any kind of
> confusion.

Well, it confused me a lot in this particular case...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
