Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbXI1RVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbXI1RVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 13:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbXI1RV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 13:21:28 -0400
Received: from hpsmtp-eml19.kpnxchange.com ([213.75.38.84]:55290 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753250AbXI1RV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:21:27 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [mm] Better help needed for UEVENT_HELPER_PATH
Date: Fri, 28 Sep 2007 19:21:24 +0200
User-Agent: KMail/1.9.7
Cc: Kay Sievers <kay.sievers@vrfy.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281921.24898.elendil@planet.nl>
X-OriginalArrivalTime: 28 Sep 2007 17:21:25.0084 (UTC) FILETIME=[FF3BA9C0:01C801F3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Current help for CONFIG_UEVENT_HELPER_PATH is:
   Path to uevent helper program forked by the kernel for
   every uevent.
With default value of /sbin/hotplug.

Help! I don't have /sbin/hotplug (Debian unstable, using udev).
What do I do now? Will my hardware be unsupported because I don't have
/sbin/hotplug?
Should I leave it at the default? Make it empty? Or do I need to replace 
hotplug by some other magic command?

Please extend the help text to give some context and indication of how to 
use this option.

This issue was raised before in:
http://lkml.org/lkml/2007/9/18/160

Thanks,
FJP
