Return-Path: <linux-kernel-owner+w=401wt.eu-S1757974AbXKCTBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbXKCTBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 15:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbXKCTBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 15:01:01 -0400
Received: from mail0.scram.de ([78.47.204.202]:42088 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174AbXKCTBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 15:01:00 -0400
X-Spam-Score: -3.892
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.5 AWL AWL: From: address is in the auto white-list
Message-ID: <472CC569.9050502@scram.de>
Date: Sat, 03 Nov 2007 20:00:57 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>
CC: linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>,
       Scott Wood <scottwood@freescale.com>, Jeff Garzik <jeff@garzik.org>,
       netdev <netdev@vger.kernel.org>
Subject: [PATCH0/2] [POWERPC] Two bug fixes for 2.6.24
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a series fixing some bugs for 8xx powerpc CPUs.

1. [POWERPC] Kill non-existant symbols from ksyms and commproc.h
2. [POWERPC] fs_enet: select PHYLIB as the driver needs it

This series can be pulled from git://git.bocc.de/dbox2.git for-2.6.24

Thanks,
Jochen


