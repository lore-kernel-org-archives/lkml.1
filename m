Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbZEXWLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbZEXWLm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758677AbZEXWIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:08:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34198 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758773AbZEXWIN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:08:13 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "fanderay" <fanderay4@googlemail.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Len Brown" <len.brown@intel.com>, "Lin Ming" <ming.m.lin@intel.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Mattia Dongili" <malattia@linux.it>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
In-Reply-To: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <uSztiUhmDDC.A.VwB.v-bGKB@chimera>
Subject: [Bug #13148] resume after suspend-to-ram broken on Sony Vaio VGN-SR19VN when sony-laptop driver present
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 May 2009 21:11:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13148
Subject		: resume after suspend-to-ram broken on Sony Vaio VGN-SR19VN when sony-laptop driver present
Submitter	: fanderay <fanderay4@googlemail.com>
Date		: 2009-04-22 14:39 (33 days old)


