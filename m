Return-Path: <linux-kernel-owner+w=401wt.eu-S1756323AbXFKSjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbXFKSjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 14:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbXFKSjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 14:39:09 -0400
Received: from cpsmtp-voip02.KPNplanet.nl ([213.75.38.82]:56296 "EHLO
	cpsmtp-voip02.KPNplanet.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753811AbXFKSjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 14:39:08 -0400
X-Greylist: delayed 859 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jun 2007 14:39:08 EDT
Message-ID: <466D9440.3080005@kpnplanet.nl>
Date: Mon, 11 Jun 2007 20:28:16 +0200
From: api <linuxgent@kpnplanet.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.4) Gecko/20070607 SeaMonkey/1.1.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: scsi disk help file is not complete
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2007 18:24:43.0992 (UTC) FILETIME=[C8884580:01C7AC55]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Good day,
When doing make menuconfig one comes across CONFIG_BLK_DEV_SD.
The help file states that this is for scsi disks.NO MENTION IS MADE THAT
IT IS NEEDE FOR SATA DISKS AS WELL!
Would have saved me a lot of time if the help was up to date.
I hope this can be changed so others can make a kernel for sata systems
quicker.
Thanks,
Gerard
