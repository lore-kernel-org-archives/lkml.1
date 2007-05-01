Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbXEAWeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbXEAWeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbXEAWeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:34:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49449 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbXEAWd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:33:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4637C04E.4070306@s5r6.in-berlin.de>
Date: Wed, 02 May 2007 00:33:50 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andre Tomt <andre@tomt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: so ... what *are* candidates for removal?
References: <Pine.LNX.4.64.0705011050080.11853@localhost.localdomain>            <46375D1C.4050404@tomt.net> <10590.1178037443@turing-police.cc.vt.edu>
In-Reply-To: <10590.1178037443@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Tue, 01 May 2007 17:30:36 +0200, Andre Tomt said:
>> Robert P. J. Day wrote:
> 
>>> http://fsdev.net/wiki/index.php?title=Stuff_to_be_removed
> 
>> Already documented in the kernel tarball, see 
>> Documentation/feature-removal-schedule.txt
> 
> Robert's point is that the file you cited is horrendously out of date, and
> we need to create a consensus of what *should* be in feature-removal-schedule.txt
> so we can update it to correspond to some sort of reality, or at the very least
> some politically correct sanitized view of reality. It currently lists
> stuff scheduled to be removed 18 months ago, and doesn't list stuff that
> everybody agrees deserves to be heaved over the side as soon as the users have
> had "enough warning" (whatever that means)....

It means to get in touch with people who are affected.  Yes, that's the
tough part.

Regarding features that are overdue for removal according to
feature-removal-schedule.txt:

I remember that at least one person used to watch for due dates for
feature removal, wrote the removing patches, and sent them to the
appropriate lists and maintainers.  This either got rid of the obsolete
stuff, or it turned up reasons why some feature could not be removed
just yet and how to update feature-removal-schedule.txt to correctly
reflect that.

So, as they say, Patches Are Welcome.
-- 
Stefan Richter
-=====-=-=== -=-= ---=-
http://arcgraph.de/sr/
