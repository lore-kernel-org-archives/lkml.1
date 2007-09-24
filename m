Return-Path: <linux-kernel-owner+w=401wt.eu-S1761640AbXIXRMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761640AbXIXRMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760978AbXIXRMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:12:30 -0400
Received: from mail0.scram.de ([78.47.204.202]:40526 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760966AbXIXRM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:12:29 -0400
X-Spam-Score: -3.89
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.5 AWL AWL: From: address is in the auto white-list
Message-ID: <46F7EFFA.9070203@scram.de>
Date: Mon, 24 Sep 2007 19:12:26 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: linuxppc-embedded@ozlabs.org
CC: linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>
Subject: [PATCH#2 0/4] Various bug fixes
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a series fixing some bugs for 8xx powerpc CPUs.

1. [POWERPC] Fix copy'n'paste typo in commproc.c
2. [PPC] Fix cpm_dpram_addr returning phys mem instead of virt mem
3. [PPC] Compile fix for 8xx CPM Ehernet driver
4. [POWERPC] Fix cpm_uart driver (updated)

This series can be pulled from git://git.bocc.de/dbox2.git ppc-fixes

Thanks,
Jochen
