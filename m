Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbYLZVqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbYLZVqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 16:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbYLZVq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 16:46:27 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34414 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbYLZVq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 16:46:26 -0500
Date: Fri, 26 Dec 2008 22:46:25 +0100
From: Pavel Machek <pavel@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Theodore Tso <tytso@mit.edu>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: SD/MMC cards: how crappy they are?
Message-ID: <20081226214625.GA25153@atrey.karlin.mff.cuni.cz>
References: <20081202144830.GB1549@ucw.cz> <493562A5.40308@zytor.com> <20081202165608.GD18162@mit.edu> <4935778E.1020405@zytor.com> <20081204103206.GD22396@elf.ucw.cz> <49382973.4000908@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49382973.4000908@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Pavel Machek wrote:
> >>>
> >> I have seen flash cards die permanently from having a partition table it
> >> didn't like written to it.  Yes, the microcontroller on the flash card
> >> tried to interpret the partition table, assumed to be MS-DOS style, and
> >> would crash.
> > 
> > Aha... that explains why I killed few flashcards by tar xzvf /dev/sdX files
> > ... hopefully thats fixed in the better/bigger cards now.
> > 
> 
> Also had a batch of cards which would silently "correct" the partition
> table for you to align the partitions to its flash erase blocks.

Can you mention the manufacturer/model? Silendt data corruption is a
nasty thing....
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
