Return-Path: <linux-kernel-owner+w=401wt.eu-S1751847AbXCDQlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbXCDQlY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 11:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbXCDQlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 11:41:24 -0500
Received: from wx-out-0506.google.com ([66.249.82.234]:35780 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbXCDQlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 11:41:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mFWtvaPBl1Cv6IaaMwIR8+m6NhECtpiMzUQlbppqkzic2Fcwd717z3z3VnmWrxwJOSbh5U1tNWNDWTFK8g7BezW6qR4c3QzKwGaT9tioNvhbJh8EPwmyuncopIhIuLactmEu/i/Ii2PoZTVKi5RfpqEmZsLHQyw56Jdax9LMpwQ=
Message-ID: <8d158e1f0703040841m634b37d4r9f2d4135f5f4dfd6@mail.gmail.com>
Date: Sun, 4 Mar 2007 16:41:21 +0000
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [IPW3945] Can't load microcode
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just downloaded the latest kernel drivers, daemon and microcode for
my Intel Wireless card. everything built correctly, the microcode is
placed in /lib/firmware and when running /etc/init.d/ipw3945d-start I
get the following dmesg

ieee80211_crypt: registered algorithm 'NULL'
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ipw3945: Intel(R) PRO/Wireless 3945 Network Connection driver for Linux, 1.2.0d
ipw3945: Copyright(c) 2003-2006 Intel Corporation
ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 18 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:05:00.0 to 64
ipw3945: Detected Intel PRO/Wireless 3945ABG Network Connection
ipw3945: ipw3945.ucode load failed: Reason -2
ipw3945: Could not read microcode: -2
ipw3945: probe of 0000:05:00.0 failed with error -2


What am I doing wrong?


Patrick
