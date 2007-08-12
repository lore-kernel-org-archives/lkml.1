Return-Path: <linux-kernel-owner+w=401wt.eu-S938524AbXHLUHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938524AbXHLUHd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 16:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761442AbXHLUHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 16:07:23 -0400
Received: from dimail1.hmi.de ([134.30.95.50]:49739 "EHLO dimail1.hmi.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758213AbXHLUHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 16:07:22 -0400
Message-ID: <46BF6853.4020800@lns.pnpi.spb.ru>
Date: Mon, 13 Aug 2007 00:06:43 +0400
From: Vadim Dyadkin <dyadkin@lns.pnpi.spb.ru>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: troubles with r8169
References: <fa.BZqd/vLw75Xm+ORj+HLjUzU1hSw@ifi.uio.no> <46BF61AB.5060400@shaw.ca>
In-Reply-To: <46BF61AB.5060400@shaw.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0a4 (dimail1.hmi.de [134.30.95.94]); Sun, 12 Aug 2007 22:07:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock пишет:
> This could well be a problem with the nvidia driver as it shares the
> same IRQ. The first step would be to see if the problem still shows up
> without the nvidia binary module loaded.

Thank for your answer. This problem never shows up if I use only nvidia
driver (the work without network), or if I use only r8169 (without
x.org). If I use both of them I have the hang. Usually the hang appears
if OpenGL is used or network rate is maximal. I tested this regimes many
times before.

Vadim
