Return-Path: <linux-kernel-owner+w=401wt.eu-S1762221AbZCNWDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221AbZCNWDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 18:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759044AbZCNV61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:58:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41884 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759382AbZCNV6Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:58:25 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Reinette Chatre" <reinette.chatre@intel.com>,
       "Stefan Seyfried" <seife@suse.de>,
       "Tomas Winkler" <tomas.winkler@intel.com>, "Zhu Yi" <yi.zhu@intel.com>,
       "Zhu, Yi" <yi.zhu@intel.com>
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera>
In-Reply-To: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <qm8_cedJGaP.A.NiG.nOCvJB@chimera>
Subject: [Bug #12818] iwlagn broken after suspend to RAM (iwlagn: MAC is in deep sleep!)
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12818
Subject		: iwlagn broken after suspend to RAM (iwlagn: MAC is in deep sleep!)
Submitter	: Stefan Seyfried <seife@suse.de>
Date		: 2009-03-04 08:32 (11 days old)


