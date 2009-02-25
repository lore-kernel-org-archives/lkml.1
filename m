Return-Path: <linux-kernel-owner+w=401wt.eu-S1761630AbZBYKYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761630AbZBYKYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759620AbZBYKYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:24:22 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:47752 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982AbZBYKYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:24:21 -0500
X-BigFish: VPS-6(z5edJz4015Mzzzzz32i6bh64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KFMA84-02-5C8-01
Date: Wed, 25 Feb 2009 11:23:37 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 0/7 v2] x86: memtest update
Message-ID: <20090225102337.GP6298@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Feb 2009 10:24:05.0484 (UTC) FILETIME=[2F9EEAC0:01C99733]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second try to cleanup the memtest code a little bit.
Addressing the issues with the first version of this patch set.

Please apply.


Thanks,

Andreas


