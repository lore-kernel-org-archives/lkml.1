Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbZGZXfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbZGZXfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbZGZXfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:35:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58814 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244AbZGZXfi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:35:38 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Shaohua Li" <shaohua.li@intel.com>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
In-Reply-To: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <H5-1lZIIeYK.A.hdH.DYObKB@chimera>
Subject: [Bug #13424] possible deadlock when doing governor switching
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jul 2009 22:45:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13424
Subject		: possible deadlock when doing governor switching
Submitter	: Shaohua Li <shaohua.li@intel.com>
Date		: 2009-05-31 16:36 (57 days old)
References	: http://www.spinics.net/lists/cpufreq/msg00711.html
		  http://lkml.org/lkml/2009/6/28/405
Handled-By	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>


