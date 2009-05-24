Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbZEXW2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbZEXW2O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758692AbZEXW1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:27:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34471 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758240AbZEXW04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:26:56 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "DRI" <dri-devel@lists.sourceforge.net>,
       "Helge Bahmann" <helge.bahmann@secunet.com>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera>
In-Reply-To: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <WCcYF-TAbJC.A.jME.rRcGKB@chimera>
Subject: [Bug #12899] Crash in i915.ko: i915_driver_irq_handler
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 May 2009 21:31:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12899
Subject		: Crash in i915.ko: i915_driver_irq_handler
Submitter	: Helge Bahmann <helge.bahmann@secunet.com>
Date		: 2009-03-20 07:13 (66 days old)


