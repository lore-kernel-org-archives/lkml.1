Return-Path: <linux-kernel-owner+w=401wt.eu-S1760506AbZDQAjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760506AbZDQAjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759561AbZDQAeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:34:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36562 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759539AbZDQAeL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:34:11 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Benjamin Li" <benli@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Matt Carlson" <mcarlson@broadcom.com>,
       "Michael Chan" <mchan@broadcom.com>, "Robin Holt" <holt@sgi.com>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
In-Reply-To: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nY3-4PrO6XH.A.LI.Sw85JB@chimera>
Subject: [Bug #13111] Linux 2.6.30-rc1 tg3 endian issues with MAC addresses on BCM5701
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 16 Apr 2009 23:45:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13111
Subject		: Linux 2.6.30-rc1 tg3 endian issues with MAC addresses on BCM5701
Submitter	: Robin Holt <holt@sgi.com>
Date		: 2009-04-08 7:12 (9 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e4f341103e4a2b35f56a0f89802f1b1448e8d04b
References	: http://marc.info/?l=linux-kernel&m=123917477312823&w=4
Handled-By	: Matt Carlson <mcarlson@broadcom.com>


