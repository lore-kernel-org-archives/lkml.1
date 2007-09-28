Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbXI1UZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbXI1UZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 16:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbXI1UZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 16:25:24 -0400
Received: from hpsmtp-eml12.kpnxchange.com ([213.75.38.112]:6159 "EHLO
	hpsmtp-eml12.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468AbXI1UZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 16:25:23 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [2.6.23-rc8-mm2] System hangs (loops?) during boot
Date: Fri, 28 Sep 2007 22:25:21 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709282225.21530.elendil@planet.nl>
X-OriginalArrivalTime: 28 Sep 2007 20:25:21.0754 (UTC) FILETIME=[B199DBA0:01C8020D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My Toshiba Satellite A40 (i386, P4 ) hangs during boot after:
Marking TSC unstable due to: possible TSC halt in C2.
Time: acpi_pm clocksource has been installed.

It may not actually hang, but rather end up in a loop as after some time the 
fan goes wild.

System boots fine with 2.6.23-rc8. Have not tried earlier mm releases.

Any suggestions where to look before I do a bisect?

Cheers,
FJP
