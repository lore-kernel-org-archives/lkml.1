Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbZGZXhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbZGZXhN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbZGZXhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:37:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58899 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbZGZXhF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:37:05 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexander Kaltsas" <alexkaltsas@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Hugh Dickins" <hugh.dickins@tiscali.co.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Mel Gorman" <mel@csn.ul.ie>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
In-Reply-To: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <H5-1lZIIeYK.A.88F.6WObKB@chimera>
Subject: [Bug #13681] A number of usb Devices causes Oops messages and kernel panics.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jul 2009 22:45:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13681
Subject		: A number of usb Devices causes Oops messages and kernel panics.
Submitter	: Alexander Kaltsas <alexkaltsas@gmail.com>
Date		: 2009-06-30 13:06 (27 days old)


