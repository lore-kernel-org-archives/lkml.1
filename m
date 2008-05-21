Return-Path: <linux-kernel-owner+w=401wt.eu-S936396AbYEUV3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936396AbYEUV3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbYEUV33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:29:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53771 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbYEUV31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:29:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: Suspend and hibernation patchset for 2.6.26-rc3
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Nigel Cunningham <ncunningham@crca.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 21 May 2008 23:29:57 +0200
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200805212329.59539.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For everyone interested, I have put together a patchset containing some "fresh"
patches related to suspend and hibernation, on top of 2.6.26-rc3, located at:

http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.26-rc3/patches/

Patches 01-06 and 11 have been sent to Len as 2.6.27 material.  They have
been tested by me for some time (except for the most recent changes in patches
01 and 11) and have not lead to any problems so far.

Patches 07-10 are in the Jesse's PCI tree, targeted at 2.6.27.

Thanks,
Rafael
