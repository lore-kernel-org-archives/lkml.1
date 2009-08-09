Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbZHJALq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbZHJALq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 20:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbZHJALo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 20:11:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44149 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbZHJAGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 20:06:24 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Rafal Kaczynski" <fscnoboot@wp.pl>
References: <YCu3FOC0QrC.A.MaE.RD2fKB@chimera>
In-Reply-To: <YCu3FOC0QrC.A.MaE.RD2fKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pRuaDVjxFBG.A.9wE.mD2fKB@chimera>
Subject: [Bug #13795] abnormal boot and no suspend due to 'async' (fastboot)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Aug 2009 23:10:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13795
Subject		: abnormal boot and no suspend due to 'async' (fastboot)
Submitter	: Rafal Kaczynski <fscnoboot@wp.pl>
Date		: 2009-07-18 17:19 (23 days old)


