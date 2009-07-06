Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbZGGAEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbZGGAEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbZGGAES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:04:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58000 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbZGGAEN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:04:13 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "=?utf-8?q?Tiago=20Sim=C3=B5es=20Batista?=" <tiagosbatista@gmail.com>,
       "Zhang Rui" <rui.zhang@intel.com>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
In-Reply-To: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bXZeuxPQAWE.A.zqB.SDpUKB@chimera>
Subject: [Bug #13109] High latency on /sys/class/thermal
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 01:57:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13109
Subject		: High latency on /sys/class/thermal
Submitter	: Tiago Simões Batista <tiagosbatista@gmail.com>
Date		: 2009-04-11 14:56 (87 days old)
References	: http://marc.info/?l=linux-kernel&m=123946182301248&w=4
Handled-By	: Zhang Rui <rui.zhang@intel.com>
		  Alexey Starikovskiy <astarikovskiy@suse.de>


