Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbZDYWVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbZDYWVp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 18:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbZDYWSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 18:18:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41663 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054AbZDYWSl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 18:18:41 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dan Williams" <dan.j.williams@intel.com>,
       "Stephen Hemminger" <shemminger@vyatta.com>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
In-Reply-To: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Fg2zLW93smL.A.oGE.Zd48JB@chimera>
Subject: [Bug #13116] Can't boot with nosmp
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Apr 2009 21:31:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13116
Subject		: Can't boot with nosmp
Submitter	: Stephen Hemminger <shemminger@vyatta.com>
Date		: 2009-04-15 4:18 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=123976917817920&w=4
Handled-By	: Dan Williams <dan.j.williams@intel.com>


