Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbYGDQLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbYGDQLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757017AbYGDQLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:11:23 -0400
Received: from main.gmane.org ([80.91.229.2]:47087 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757004AbYGDQLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:11:23 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH] PalmTX initial support
Date: Fri, 4 Jul 2008 16:11:10 +0000 (UTC)
Message-ID: <g4li2u$l3c$1@ger.gmane.org>
References: <200807022232.47294.marek.vasut@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: iap-pxy-mow1.siemens.ru
User-Agent: Pan/0.132 (Waxed in Black)
Cc: linux-arm-kernel@lists.arm.linux.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marek Vašut wrote:

> Hi,
> the following patch adds initial support for PalmTX handheld computer.
> It originates from HnD kernel tree (www.hackndev.com), then I pushed it
> to handhelds.org and now I'd like it to be applied mainline.
> 
> PalmTX is pxa27x based handheld computer.
> 
> Currently supported - mmc, gpio keys, pxa matrix keypad, irda,
> framebuffer, ac97 port (for touchscreen).
> 
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>

Please consider switching ac97 driver to ASoC-based one.

-- 
With best wishes
Dmitry


