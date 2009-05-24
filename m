Return-Path: <linux-kernel-owner+w=401wt.eu-S1760840AbZEXWda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760840AbZEXWda (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759685AbZEXW2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:28:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34553 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759453AbZEXW2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:28:37 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alex Samad" <alex@samad.com.au>, "Dave Chinner" <david@fromorbit.com>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera>
In-Reply-To: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <WCcYF-TAbJC.A.RuC.RQcGKB@chimera>
Subject: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 May 2009 21:31:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13375
Subject		: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Submitter	: Alex Samad <alex@samad.com.au>
Date		: 2009-05-20 0:37 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=124278675503699&w=4


