Return-Path: <linux-kernel-owner+w=401wt.eu-S1762329AbZCNWCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762329AbZCNWCu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 18:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759487AbZCNV6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:58:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41889 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758991AbZCNV62 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:58:28 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andi Kleen" <ak@linux.intel.com>,
       "Carlos Corbacho" <carlos@strangeworlds.co.uk>,
       "Len Brown" <len.brown@intel.com>,
       "Michael Spang" <mspang@csclub.uwaterloo.ca>,
       "Thomas Renninger" <trenn@suse.de>, "Zhang Rui" <rui.zhang@intel.com>
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera>
In-Reply-To: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <qm8_cedJGaP.A.waG.lOCvJB@chimera>
Subject: [Bug #12835] Regression in backlight detection
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Mar 2009 20:20:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12835
Subject		: Regression in backlight detection
Submitter	: Michael Spang <mspang@csclub.uwaterloo.ca>
Date		: 2009-02-24 5:41 (19 days old)
References	: http://marc.info/?l=linux-kernel&m=123545411502396&w=4
Handled-By	: Michael Spang <mspang@csclub.uwaterloo.ca>
Patch		: http://marc.info/?l=linux-kernel&m=123545411502396&w=4


