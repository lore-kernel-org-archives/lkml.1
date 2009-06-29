Return-Path: <linux-kernel-owner+w=401wt.eu-S1758541AbZF2ATz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541AbZF2ATz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757923AbZF2ARN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:17:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38499 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757545AbZF2ARL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:17:11 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Frans Pop" <elendil@planet.nl>,
       "Johannes Berg" <johannes@sipsolutions.net>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
In-Reply-To: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6JJ2m5kyucK.A.keC.6IASKB@chimera>
Subject: [Bug #13659] iwlagn (4965): no wireless due to RFKILL problem
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 29 Jun 2009 02:11:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13659
Subject		: iwlagn (4965): no wireless due to RFKILL problem
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2009-06-26 13:36 (3 days old)
References	: http://lkml.org/lkml/2009/6/26/127
Handled-By	: Johannes Berg <johannes@sipsolutions.net>
Patch		: http://lkml.org/lkml/2009/6/27/35


