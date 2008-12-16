Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbYLPSHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbYLPSHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYLPSHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:07:04 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:19620 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYLPSHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:07:02 -0500
X-BigFish: VPS-4(zz4015Mzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBZEB0-01-C9K-01
Date: Tue, 16 Dec 2008 19:06:39 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: [PATCH 0/10] x86: microcode_amd: fixes and cleanup
Message-ID: <20081216180639.GG7013@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Dec 2008 18:06:42.0666 (UTC) FILETIME=[0CDC84A0:01C95FA9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following a small series of patches to cleanup microcode_amd. Patch 1
might be of interest for .28. But I don't know whether you are willing to
apply the whole series for .28.

In any case the stuff should go into .29.


Thanks,

Andreas


