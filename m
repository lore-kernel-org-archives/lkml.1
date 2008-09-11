Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbYIKXZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbYIKXZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 19:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYIKXZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 19:25:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbYIKXZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 19:25:24 -0400
Message-ID: <48C9A8C4.9080803@redhat.com>
Date: Thu, 11 Sep 2008 19:24:52 -0400
From: Chuck Ebbert <cebbert@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
CC: stable@kernel.org
Subject: [stable] Unfixed regressions in 2.6-stable
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Description: Thermal shutdown on x86 systems
Version(s):  2.6.25.14 - 2.6.25.17
Caused-by:   http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_plain;f=releases/2.6.25.14/cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init-funcs-got-called-already.patch;hb=HEAD
Version(s):  2.6.26.1 - 2.6.26.5
Caused-by:   http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_plain;f=releases/2.6.26.1/cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init-funcs-got-called-already.patch;hb=HEAD
Patch:       http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=613e5f3376e48bd48494cf780b79b97b057d49a7
              http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=9f497bcc695fb828da023d74ad3c966b1e58ad21
Patch is in mainline.


Description: Kernel hangs when booting on Sony PS3
Version(s):  2.6.25.12 - 2.6.25.17
Caused-by:   http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_plain;f=releases/2.6.25.12/usb-fix-interrupt-disabling-for-hcds-with-shared-interrupt-handlers.patch;hb=HEAD
Version(s):  2.6.26 - 2.6.26.5
Caused-by:   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=de85422b94ddb23c021126815ea49414047c13dc
Patch:       http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob_plain;f=usb.current/usb-fix-hcd-interrupt-disabling.patch;hb=HEAD
Patch is not in mainline.
