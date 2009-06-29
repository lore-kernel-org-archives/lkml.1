Return-Path: <linux-kernel-owner+w=401wt.eu-S1760123AbZF2Akj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123AbZF2Akj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758870AbZF2Ag0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:36:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38718 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758230AbZF2AgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:36:23 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Shaohua Li" <shaohua.li@intel.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
In-Reply-To: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <5Hhc7UkUKEO.A.IOG.9jASKB@chimera>
Subject: [Bug #13424] possible deadlock when doing governor switching
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 29 Jun 2009 02:30:56 +0200 (CEST)
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
Date		: 2009-05-31 16:36 (29 days old)
References	: http://www.spinics.net/lists/cpufreq/msg00711.html
Handled-By	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>


