Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYEWMvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYEWMvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 08:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYEWMvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 08:51:40 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:25468 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751940AbYEWMvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 08:51:39 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0K1BNHH-02-2V8-01
Date: Fri, 23 May 2008 14:46:23 +0200
From: Robert Richter <robert.richter@amd.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Enable mmconf access to PCI ECS for all AMD fam10h systems
Message-ID: <20080523124622.GV27511@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 23 May 2008 12:46:23.0867 (UTC) FILETIME=[020E44B0:01C8BCD3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai,

We would like to enable ECS for all fam10h systems. What was the
reason for patch 5f0b2976 that enables it for Sun systems only? If
there are no objections, this patch should be reverted.

Thomas,

is there a chance to revert the patch for 2.6.26?

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

