Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbZIIXmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbZIIXmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZIIXmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:42:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35979 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbZIIXly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:41:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/9] PM: Asynchronous suspend of devices
Date: Thu, 10 Sep 2009 01:27:11 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-rjw; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909100127.11252.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series of patches implements asynchronous suspend and resume of
devices.

All of the patches have already been discussed, please refer to the changelogs
for details.

The patches are targeted at 2.6.33, so if there are no major objections, I'll
put them into the linux-next branch of the suspend-2.6 tree after .31-rc1 is
out.

Thanks,
Rafael

