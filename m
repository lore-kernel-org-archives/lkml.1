Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbYEWR2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbYEWR2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbYEWR2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:28:40 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:36559 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbYEWR2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:28:39 -0400
To: linux-kernel@vger.kernel.org,
       ksummit-2008-discuss@lists.linux-foundation.org
Subject: 2008 Linux Kernel Summit
From: "Theodore Ts'o" <tytso@MIT.EDU>
Phone: (781) 391-3464
Message-Id: <E1Jzb3a-0008DS-Tu@closure.thunk.org>
Date: Fri, 23 May 2008 13:27:54 -0400
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

        It's time to start kicking off the 2008 Kernel Summit planning
process.  This year, the Kernel Summit will be held in Portland, Oregon,
on September 15-16, just before the Plumber's conference.

	As in previous years, I've set up a e-mail discussion list for
people who are interested in making suggestions for this year's kernel
summit.  In the probably hopeless attempt to avoid the list address
getting instantly harvested by spammers from all of the LKML archives,
the list submission address and subscription URL can be found by
executing the following perl script:

#!/usr/bin/perl
$at="@";
$AD=(gmtime(time))[5]+1900;
print "ksummit-" . $AD . "-discuss" . $at . "thunk.org\n";
print "http://lists.linux-foundation.org/mailman/listinfo/ksummit-" . $AD . "-discuss\n";

This year's program committe is:

	Anton Blanchard
	Jonathon Corbet
	James Bottomley
	Dirk Hohndel
	Dave Jones
	Greg Kroah-Hartman
	Chris Mason
	Andrew Morton
	Theodore Ts'o
	Arjan De Ven

If you have any questions, please feel to contact me or the entire
kernel summit program committee.  Our contact e-mail address can be
found by taking the output from the above perl script and running it
through the command: "sed -e 's/discuss/pc/'".

Regards,

						- Ted

