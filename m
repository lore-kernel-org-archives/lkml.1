Return-Path: <linux-kernel-owner+w=401wt.eu-S1161147AbXBABJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161147AbXBABJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 20:09:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161167AbXBABJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 20:09:03 -0500
Received: from rtr.ca ([64.26.128.89]:1602 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161147AbXBABJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 20:09:01 -0500
Message-ID: <45C13DAB.5090305@rtr.ca>
Date: Wed, 31 Jan 2007 20:08:59 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <32793.192.54.193.51.1170248792.squirrel@rousalka.dyndns.org>	<20070131201258.GB15128@kroah.com>	<20070131230014.GD20514@thunk.org> <20070131150451.070fa90f.randy.dunlap@oracle.com>
In-Reply-To: <20070131150451.070fa90f.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Wed, 31 Jan 2007 18:00:15 -0500 Theodore Tso wrote:
..
>> More specifically, Dave said that it "seemed rude" to just take the
>> driver and send updates, but maybe the best way of dealing with
>> out-of-tree drivers like lirc is to treat the out-of-tree drivers as a
>> kind of spec release, and just have someone in the community forcibly
>> take the code, fix it up, and then get it merged.  Maybe it's being
>> "rude", but so is not responding to requests to get it merged.

I believe a BIG reason why lots of open-source drivers are out-of-tree
right now, is because lkml is perceived as being wayyyyyy too fussy
and petty about 80-column lines, brackets, etc.. for new code.

It's just not worth the effort/abuse for many maintainers to pursue it.

> and I'm quite willing to apply Doc/CodingStyle to driver source file(s).
> That's as easy as replying to an email with comments about it.

That's a very decent offer, and exactly what's needed here!

Cheers
