Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYHAKta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYHAKta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 06:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYHAKtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 06:49:23 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:21926 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750789AbYHAKtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 06:49:22 -0400
X-BigFish: VPS-1(zz4015Mzz10d3izzz32i8ah43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K4X4PY-01-GT9-01
Message-ID: <20080801104644.788786464@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 1 Aug 2008 12:46:44 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [patch 0/2] x86: microcode patch loader cleanup and fix
X-OriginalArrivalTime: 01 Aug 2008 10:49:11.0020 (UTC) FILETIME=[3B117AC0:01C8F3C4]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set cleans up vendor independent microcode loading module and corrects one misbehaviour
in AMD specific module.

Thanks,
Peter




