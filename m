Return-Path: <linux-kernel-owner+w=401wt.eu-S1760946AbXGaOpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbXGaOpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759590AbXGaOpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:45:17 -0400
Received: from main.gmane.org ([80.91.229.2]:39900 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758240AbXGaOpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:45:15 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Neal Becker <ndbecker2@gmail.com>
Subject: garmin_gps not working with etrex vista cx
Date: Tue, 31 Jul 2007 10:44:39 -0400
Message-ID: <f8nht6$pfl$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: nat-expu-252-55.hns.com
User-Agent: KNode/0.10.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I can't seem to transfer routes to my garmin etrex vista cx.  I get
(repeatably) truncated routes, and:
Jul 31 07:19:07 nbecker4 kernel: usb 2-2: reset full speed USB device using
ohci_hcd and address 3
Jul 31 07:24:05 nbecker4 kernel: usb 2-2: reset full speed USB device using
ohci_hcd and address 3
Jul 31 07:26:04 nbecker4 last message repeated 3 times
...

The problem must be the kernel driver, because I can d/l the same file using
windoze without problems.

Jul 31 07:13:18 nbecker4 kernel: garmin_gps 2-2:1.0: Garmin GPS usb/tty
converter detected


