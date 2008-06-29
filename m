Return-Path: <linux-kernel-owner+w=401wt.eu-S1761964AbYF2TgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761964AbYF2TgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 15:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759569AbYF2Tb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:31:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45685 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759124AbYF2TbZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:31:25 -0400
Cc: "Adam Williamson" <awilliamson@mandriva.com>,
       "Oliver Neukum" <oliver@neukum.org>
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
In-Reply-To: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <X8mbwW6K81I.A.x9E.379ZIB@albercik>
Subject: [Bug #10868] Oops on loading ipaq module since 2.6.26, prevents use of device
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 29 Jun 2008 20:18:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10868
Subject		: Oops on loading ipaq module since 2.6.26, prevents use of device
Submitter	: Adam Williamson <awilliamson@mandriva.com>
Date		: 2008-06-05 17:39 (25 days old)
References	: http://marc.info/?t=121287647600002&r=1&w=4
Handled-By	: Oliver Neukum <oliver@neukum.org>


