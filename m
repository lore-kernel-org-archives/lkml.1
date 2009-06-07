Return-Path: <linux-kernel-owner+w=401wt.eu-S1758448AbZFGNKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448AbZFGNKk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757965AbZFGNHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:07:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58587 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757928AbZFGNHd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:07:33 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "fanderay" <fanderay4@googlemail.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Len Brown" <len.brown@intel.com>, "Lin Ming" <ming.m.lin@intel.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Mattia Dongili" <malattia@linux.it>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera>
In-Reply-To: <sIiXQlfwS3D.A.81.dj7KKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <AN6kEAA5GQ.A.f6B.Sk7KKB@chimera>
Subject: [Bug #13148] resume after suspend-to-ram broken on Sony Vaio VGN-SR19VN when sony-laptop driver present
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Jun 2009 12:06:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13148
Subject		: resume after suspend-to-ram broken on Sony Vaio VGN-SR19VN when sony-laptop driver present
Submitter	: fanderay <fanderay4@googlemail.com>
Date		: 2009-04-22 14:39 (47 days old)


