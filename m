Return-Path: <linux-kernel-owner+w=401wt.eu-S1759600AbYLLSH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600AbYLLSH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 13:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757643AbYLLSHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 13:07:16 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:32207 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501AbYLLSHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 13:07:15 -0500
X-BigFish: VPS-12(z6c9Rz4015Mzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KBRZNK-01-K17-01
Date: Fri, 12 Dec 2008 19:06:50 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] x86: mcheck: suspend/resume bug fixes
Message-ID: <20081212180650.GS19144@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Dec 2008 18:07:01.0848 (UTC) FILETIME=[6EA47580:01C95C84]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following two patches fix suspend/resume issues with current kernel.
Patches are against v2.6.28-rc8-1-g6c34bc2
IMHO this should go into .28.


Thanks,

Andreas


