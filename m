Return-Path: <linux-kernel-owner+w=401wt.eu-S1760181AbZDQAgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181AbZDQAgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759474AbZDQAdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:33:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36528 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759456AbZDQAd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:33:29 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Stephen Hemminger" <shemminger@vyatta.com>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
In-Reply-To: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nY3-4PrO6XH.A.Q2.cw85JB@chimera>
Subject: [Bug #13099] net, sky2: BUG: unable to handle kernel NULL pointer dereference, pci_vpd_truncate()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 16 Apr 2009 23:45:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13099
Subject		: net, sky2: BUG: unable to handle kernel NULL pointer dereference, pci_vpd_truncate()
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2009-04-06 9:03 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=123900867611321&w=4
Handled-By	: Stephen Hemminger <shemminger@vyatta.com>


