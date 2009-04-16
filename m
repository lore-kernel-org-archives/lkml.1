Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbZDQAh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbZDQAh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759482AbZDQAdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:33:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36525 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759462AbZDQAda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:33:30 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
In-Reply-To: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nY3-4PrO6XH.A.9FB.gw85JB@chimera>
Subject: [Bug #13096] 2.6.30-rc2 hangs in get_measured_perf on tigerton
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 16 Apr 2009 23:45:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13096
Subject		: 2.6.30-rc2 hangs in get_measured_perf on tigerton
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-04-15 14:01 (2 days old)
References	: http://lkml.org/lkml/2009/4/15/34
Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Patch		: http://lkml.org/lkml/2009/4/15/355


