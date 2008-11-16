Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbYKPSi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbYKPSi4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbYKPSeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:34:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42926 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbYKPSeU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:34:20 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bernhard Schmidt" <berni@birkenwald.de>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Johan Bilien" <jobi@via.ecp.fr>,
       "Romano Giannetti" <romano.giannetti@gmail.com>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
In-Reply-To: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Q7OAnAv0V3D.A.8gF.CBGIJB@chimera>
Subject: [Bug #11947] 2.6.28-rc VC switching with Intel graphics broken
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 16 Nov 2008 17:35:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11947
Subject		: 2.6.28-rc VC switching with Intel graphics broken
Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
Date		: 2008-11-03 12:10 (14 days old)
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


