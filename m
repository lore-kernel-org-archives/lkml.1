Return-Path: <linux-kernel-owner+w=401wt.eu-S1752830AbXL0QCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbXL0QCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 11:02:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbXL0QB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 11:01:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:47401 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbXL0QB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 11:01:57 -0500
To: debian-devel@lists.debian.org, linux-kernel@vger.kernel.org,
       lf_staff@linux-foundation.org,
       Head Bubba <head.bubba@credit-suisse.com>,
       Marc MERLIN <marc@merlins.org>, Reuben Thomas <rrt@sc3d.org>,
       Andreas Dilger <adilger@sun.com>, Alex Tomas <alex.tomas@sun.com>,
       Aaron Whitehouse <lists@whitehouse.org.nz>
Subject: Please ignore mail bounces for tytso-mit@thunk.org
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1J7uw2-0002HJ-60@closure.thunk.org>
Date: Thu, 27 Dec 2007 10:46:14 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, some of you may have noticed have received mail bounces from
mail that you sent me from MAILER-DAEMON@mit.edu that referenced failure
to deliver mail to tytso-mit@thunk.org, for example:

  <tytso-mit@thunk.org>... Deferred: Connection timed out with thunk.org.
  Message could not be delivered for 3 days
  Message will be deleted from queue

Some of you may have also noticed that mail sent to tytso@thunk.org may
have also started bouncing in a similar fashion.  

My apologies.  Unfortunately thunk.org failed on December 23rd, and
because I and other people who might have been able to gain physical
access to the colo facility (where the server is located) have been
travelling for the holidays, I haven't been able to get the machine back
up as quickly as I would like.  Please rest assured that mail sent to
tytso@mit.edu is being read, despite the bounce messages.
tytso-mit@thunk.org was a backup copy of mail sent to tytso@mit.edu that
I established a while back as a backup way of reading my mit.edu mail
after my mit.edu IMAP server was down for 4 days.[1]

In any case, mail service to tytso@mit.edu has not been interrupted; I
am reading mail sent there, and it is the primary way that I should be
contacted for any Linux/Open Source related matters.

Mail to tytso@thunk.org is currently being held in mail queues, and
depending on how SMTP mailers have been configured, may have started
getting returned to sender.  A few debian mailing lists are set to feed
tytso@thunk.org, and some people use it to contact me, although I
generally have not published it as a contact address.

I'm hopeful that I will get thunk.org restored fairly quickly, and
apologize for any inconvenience/confusion this may have prompted.

Regards,

						- Ted

[1] An interesting story, which involved the MIT I/T staff waiting 36+
hours for a Solaris ufs fsck to finish on a 1TB filesystem, before
aborting it in frustration and using other methods to restore service,
but for another day.
