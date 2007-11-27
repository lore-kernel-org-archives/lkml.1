Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbXK0IqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbXK0IqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 03:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbXK0IqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 03:46:06 -0500
Received: from mx10.go2.pl ([193.17.41.74]:39439 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752758AbXK0IqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 03:46:05 -0500
Date: Tue, 27 Nov 2007 09:50:38 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [RFC][PATCH] Update REPORTING-BUGS (rev. 2)
Message-ID: <20071127085038.GA1919@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711262202.24984.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26-11-2007 22:02, Rafael J. Wysocki wrote:
...
> 
> For completness, below is an updated version of the patch, modified to take
> some Adrian's comments into account.
> 
> Comments welcome.

...You mean any comments?...

Well, I've written something similar about something similar somewhere
else, which you could remember, but here I'm even more "brutal", sorry!
So, I think this text is wrong - at least in this place. I probably can
repeat some of Adrian's comments, but IMHO the main thing is that this
shouldn't deter any user, who got this, maybe momentary idea to report
something. So, it definitely shouldn't be longer than maybe 5 sentences,
with any "you should" if possible.

So, maybe it could start just like Adrian proposed:

>> Go to http://bugzilla.kernel.org/ and click on "Enter a new bug report".

plus e.g.:

"Alternatively you can write an e-mail to linux-kerel@vger.kernel.org
 with '[BUG]' at the beginning of a subject (no need to subscribe).

 If you feel like doing this with more details, read this document,
 please: ..."

Regards,
Jarek P.

PS: Btw., did you notice how even main developers respect current
(previous?) version of this doc while reporting bugs here?
