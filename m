Return-Path: <linux-kernel-owner+w=401wt.eu-S1161194AbXECHIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161194AbXECHIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 03:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161221AbXECHIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 03:08:05 -0400
Received: from www17.your-server.de ([213.133.104.17]:4202 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161194AbXECHIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 03:08:04 -0400
Message-ID: <46398A14.6060801@m3y3r.de>
Date: Thu, 03 May 2007 09:07:00 +0200
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.0 (X11/20070421)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Appletouch is gone!
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With current git head from linus' tree
and LOCALVERSION_AUTO [=y] and USB_APPLETOUCH [=m]

find /lib/modules/ -name apple*
/lib/modules/2.6.20/kernel/drivers/usb/input/appletouch.ko
/lib/modules/2.6.21/kernel/drivers/usb/input/appletouch.ko

uname -a
Linux hotzenplotz 2.6.21-gdc87c398

Any ideas?

