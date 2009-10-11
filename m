Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbZJKW0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbZJKW0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbZJKW0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:26:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57842 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbZJKW0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:26:14 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Carlos R. Mafra" <crmafra2@gmail.com>,
       "reinette chatre" <reinette.chatre@intel.com>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
In-Reply-To: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <r-4Wjt4coy.A.5fC.Ral0KB@chimera>
Subject: [Bug #14381] iwlagn lost connection after s2ram (with warnings)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Oct 2009 00:22:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14381
Subject		: iwlagn lost connection after s2ram (with warnings)
Submitter	: Carlos R. Mafra <crmafra2@gmail.com>
Date		: 2009-10-07 14:20 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=125492569119947&w=4


