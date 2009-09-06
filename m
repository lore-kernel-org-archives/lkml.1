Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbZIFVSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbZIFVSl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 17:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758840AbZIFVSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 17:18:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49089 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758838AbZIFVPA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 17:15:00 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "" <sveina@gmail.com>
References: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera>
In-Reply-To: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hKF51Pczj6N.A.9Y.q4BpKB@chimera>
Subject: [Bug #13502] GPE storm causes polling mode, which causes /proc/acpi/battery read to take 4 seconds - MacBookPro4,1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Sep 2009 20:11:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13502
Subject		: GPE storm causes polling mode, which causes /proc/acpi/battery read to take 4 seconds - MacBookPro4,1
Submitter	:  <sveina@gmail.com>
Date		: 2009-06-10 20:04 (89 days old)


