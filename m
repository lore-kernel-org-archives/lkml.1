Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbZHTEUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbZHTEUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 00:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbZHTEUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 00:20:55 -0400
Received: from mail.crca.org.au ([67.207.131.56]:40842 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbZHTEUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 00:20:54 -0400
Message-ID: <4A8CCF95.9030401@crca.org.au>
Date: Thu, 20 Aug 2009 14:22:45 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Rafael Wysocki <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@lists.tuxonice.net>
Subject: What to do?
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

A few months back, I posted TuxOnIce for something like the third time,
seeking to see if we could make some progress on getting it merged. The
outcome of that was an agreement between Rafael and I that we'd work on
getting TuxOnIce functionality (if not the actual code) merged bit by
bit, improving swsusp rather than doing an outright merge.

Unfortunately, as the intervening months have shown, Rafael is busy with
other things and so am I. The few patches I did prepare and post have
had no review, and I haven't had a chance to build on or rework them
since. (I'd actually like them not to be merged, because I've realised
that there are more foundational changes that need to go in first.)

Given that this has been the outcome so far, I see no reason to imagine
that we're going to make any serious progress any time soon.

I'd therefore like to ask whether there's anyone out there who could do
one or more of:

1) Step up to the plate and help improve swsusp, without relying on any
help from me but with my blessing if they choose to copy wholesale bits
of TuxOnIce;
2) Take over maintaining TuxOnIce from me;
3) Some other way forward that hasn't occurred to me.

Thoughts, input, flames, whatever else welcome. A lack of deadly silence
would be especially appreciated :)

Regards,

Nigel
