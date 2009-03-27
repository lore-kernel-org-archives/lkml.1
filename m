Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbZC0Ex1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbZC0Ex1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 00:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbZC0ExR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 00:53:17 -0400
Received: from thunk.org ([69.25.196.29]:39910 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbZC0ExR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 00:53:17 -0400
To: linux-kernel@vger.kernel.org
Subject: 2009 Linux Kernel Summit
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1Ln448-0002B6-9a@closure.thunk.org>
Date: Fri, 27 Mar 2009 00:53:12 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

        It's time to start kicking off the 2009 Kernel Summit planning
process.  This year, the Kernel Summit will be held in Tokyo, Japan,
on October 18-20, just before the 1st annual Japan Linux Sympsium.

	As in previous years, I've set up a e-mail discussion list for
people who are interested in making suggestions for this year's kernel
summit.  In the probably hopeless attempt to avoid the list address
getting instantly harvested by spammers from all of the LKML archives,
the list submission address and subscription URL can be found by
executing the following perl script:

#!/usr/bin/perl
$at="@";
$AD=(gmtime(time))[5]+1900;
print "ksummit-" . $AD . "-discuss" . $at . "lists.linux-foundation.org\n";
print "http://lists.linux-foundation.org/mailman/listinfo/ksummit-" . $AD . "-discuss\n";

This year's program committee is:

	James Bottomley
	Jonathon Corbet
	Dirk Hohndel
	Dave Jones
	Greg Kroah-Hartman
	Chris Mason
	Andrew Morton
	Theodore Ts'o
	Arjan van de Ven

If you have any questions, please feel to contact me or the entire
kernel summit program committee.  Our contact e-mail address can be
found by taking the output from the above perl script and running it
through the command: "sed -e 's/discuss/pc/'".

We'll give people a few days to subscribe before we kick off discussion
on the the new kernel summit mailing list.

Regards,

						- Ted

P.S.  Note that we are aware that given the economic conditions this
year, getting travel funding may be particularly difficult.  For that
reason, we have budgeted extra money for travel scholarships, and we
will be working with various Linux Foundation corporate members who have
historically sent many kernel developers to the Kernel Summit to try to
make sure that everyone who gets an invitation will be able to attend.


