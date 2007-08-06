Return-Path: <linux-kernel-owner+w=401wt.eu-S932400AbXHFKws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400AbXHFKws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763323AbXHFKwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:52:38 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50929 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763046AbXHFKwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:52:37 -0400
Date: Mon, 6 Aug 2007 12:52:36 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Few interrupts with NO_HZ
Message-ID: <Pine.LNX.4.64.0708061247150.13469@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


this more of an informational question. So:

kernel version is 2.6.22.1 on i686

/proc/uptime 
9917.81 9140.90 (2h45m)

/proc/cpuinfo:
           CPU0
  0:        282   IO-APIC-edge      timer

this is kinda neat, I expected much more interrupts than just 282 since 
boot. What kernel code actually uses the irq0 timer?


thanks,
	Jan
-- 
