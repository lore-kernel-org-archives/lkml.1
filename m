Return-Path: <linux-kernel-owner+w=401wt.eu-S932397AbYFGWFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbYFGWFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 18:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760675AbYFGVs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:48:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38945 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759679AbYFGVsl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:48:41 -0400
Cc: "Chris Clayton" <chris2553@googlemail.com>,
       "Hannes Reinecke" <hare@suse.de>,
       "James Bottomley" <James.Bottomley@HansenPartnership.com>,
       "Kay Sievers" <kay.sievers@vrfy.org>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
In-Reply-To: <GIilET9wkhI.A.JzB.81vSIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dCRO4tbfLzK.A.agC.a2vSIB@albercik>
Subject: [Bug #10861] 2.6.26-rc4-git2 - long pause during boot
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  7 Jun 2008 22:42:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10861
Subject		: 2.6.26-rc4-git2 - long pause during boot
Submitter	: Chris Clayton <chris2553@googlemail.com>
Date		: 2008-06-01 4:15 (7 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121229382917834&amp;w=4


