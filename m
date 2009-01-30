Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbZA3Uu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbZA3Uu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 15:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZA3UuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 15:50:19 -0500
Received: from nn7.de ([85.214.94.156]:44091 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175AbZA3UuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 15:50:18 -0500
Subject: 2.6.29-rc3+git macbook pro1,1 garbled display on resume
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 30 Jan 2009 21:50:09 +0100
Message-Id: <1233348609.3707.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the macbook pro suspends just fine, but even though the machine returns
to X I see on resume some random garbled output but can still move the
mouse cursor (which is OK!) and using the keyboard successfully adjust
the brightness of the display.

However I cannot switch to the console (via ctrl+alt+f1) nor does ctrl
+alt+backspace do anything....

This is on debian sid with the latest xorg radeon driver from
experimental, i.e. ii  xserver-xorg-video-radeon
1:6.9.0.91-1.

Any ideas?
Soeren
