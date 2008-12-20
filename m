Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbYLUARe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbYLUARe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 19:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYLUARI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 19:17:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50011 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbYLUARG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 19:17:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.28-rc9-git1: Reported regressions 2.6.26 -> 2.6.27
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <_EB9bLpq_z.A.hAC.NkYTJB@chimera>
Date: Sat, 20 Dec 2008 23:07:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions introduced between 2.6.26 and
2.6.27, for which there are no fixes in the mainline I know of.  If any of them
have been fixed already, please let me know.

If you know of any other unresolved regressions introduced between 2.6.26
and 2.6.27, please let me know either and I'll add them to the list.
Also, please let me know if any of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2008-12-21      203       13           9
  2008-12-13      201       11           8
  2008-12-07      200       14          12
  2008-12-04      202       16          14
  2008-11-22      199       12          10
  2008-11-16      199       18          14
  2008-11-09      196       28          23
  2008-11-02      195       34          28
  2008-10-26      190       34          29
  2008-10-04      181       41          33
  2008-09-27      173       35          28
  2008-09-21      169       45          36
  2008-09-15      163       46          32
  2008-09-12      163       51          38
  2008-09-07      150       43          33
  2008-08-30      135       48          36
  2008-08-23      122       48          40
  2008-08-16      103       47          37
  2008-08-10       80       52          31
  2008-08-02       47       31          20


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12266
Subject		: Red leds at harddisk bays on SR1530HSH after update to 2.6.27.x
Submitter	: Badalian Vyacheslav <slavon@bigtelecom.ru>
Date		: 2008-12-18 11:32 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=122959999712523&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12048
Subject		: Regression in bonding between 2.6.26.8 and 2.6.27.6
Submitter	: Jesper Krogh <jesper@krogh.cc>
Date		: 2008-11-16 9:41 (35 days old)
References	: http://marc.info/?l=linux-kernel&m=122682977001048&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12039
Subject		: Regression: USB/DVB 2.6.26.8 --&gt; 2.6.27.6
Submitter	: David <david@unsolicited.net>
Date		: 2008-11-14 20:20 (37 days old)
References	: http://marc.info/?l=linux-kernel&m=122669568022274&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11886
Subject		: without serial console system doesn't  poweroff
Submitter	: Daniel Smolik <marvin@mydatex.cz>
Date		: 2008-10-29 04:06 (53 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11876
Subject		: RCU hang on cpu re-hotplug with 2.6.27rc8
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2008-10-06 23:28 (76 days old)
References	: http://marc.info/?l=linux-kernel&m=122333610602399&w=2
Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11795
Subject		: ks959-sir dongle no longer works under 2.6.27 (REGRESSION)
Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Date		: 2008-10-20 10:49 (62 days old)
Handled-By	: Samuel Ortiz <samuel@sortiz.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11698
Subject		: 2.6.27-rc7, freezes with more than 1 s2ram cycle
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-09-29 11:29 (83 days old)
References	: http://marc.info/?l=linux-kernel&m=122268780926859&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11569
Subject		: Panic stop CPUs regression
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2008-09-02 13:49 (110 days old)
References	: http://marc.info/?l=linux-kernel&m=122036356127282&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11215
Subject		: INFO: possible recursive locking detected ps2_command
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-07-31 9:41 (143 days old)
References	: http://marc.info/?l=linux-kernel&m=121749737011637&w=4


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12261
Subject		: kernel panics with net_rx_action on kernels above 2.6.26
Submitter	: Alexander Huemer <alexander.huemer@sbg.ac.at>
Date		: 2008-12-13 18:43 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=122919424932016&w=4
Handled-By	: Jarek Poplawski <jarkao2@gmail.com>
Patch		: http://marc.info/?l=linux-net&m=122934825227768&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12200
Subject		: BUG: bad unlock balance detected! e1000e
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-12-08 11:24 (13 days old)
References	: http://marc.info/?l=linux-kernel&m=122873549700644&w=4
Handled-By	: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Patch		: http://marc.info/?l=linux-kernel&m=122905927102071&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12099
Subject		: Nokia 5310 storage-mode
Submitter	: Robson Roberto Souza Peixoto <robsonpeixoto@gmail.com>
Date		: 2008-11-25 01:07 (26 days old)
Handled-By	: Alan Stern <stern@rowland.harvard.edu>
Patch		: http://marc.info/?l=linux-kernel&m=122762731503933&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11865
Subject		: WOL for E100 Doesn't Work Anymore
Submitter	: roger <rogerx@sdf.lonestar.org>
Date		: 2008-10-26 21:56 (56 days old)
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=18646&action=view


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions introduced
between 2.6.26 and 2.6.27, unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=11167

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

