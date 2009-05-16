Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbZEPXGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbZEPXGk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 19:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758096AbZEPXBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 19:01:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44270 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758113AbZEPXBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 19:01:04 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera>
In-Reply-To: <yO1BmxN79sN.A.xAG.8_zDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pQ9WADCjgyE.A.PTG.HA0DKB@chimera>
Subject: [Bug #13186] cpufreq timer teardown problem
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 22:06:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13186
Subject		: cpufreq timer teardown problem
Submitter	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date		: 2009-04-23 14:00 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=124049523515036&w=4
Handled-By	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Patch		: http://patchwork.kernel.org/patch/19754/
		  http://patchwork.kernel.org/patch/19753/


