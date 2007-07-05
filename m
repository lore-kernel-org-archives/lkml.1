Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbXGEGU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbXGEGU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 02:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755833AbXGEGUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 02:20:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40209 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141AbXGEGUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 02:20:49 -0400
Date: Thu, 05 Jul 2007 15:20:18 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: x86_64 memory hotplug simulation support?
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200707051430.00800.nigel@nigel.suspend2.net>
References: <200707051430.00800.nigel@nigel.suspend2.net>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070705145527.2798.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello. Nigel-san.

> I'm wondering whether anyone has patches lying around that might be useful for 
> simulating memory hotplug on x86_64. Goggling has revealed some old x86 
> patches, but that's all.

I'm not sure what "simulation" means.
Could you tell me how/what do you expect memory hotplug
simulation exactly?

Memory hot-add code is included in kernel. And, remove(unplug) code
has developed (and hopefully, it will be merged to -mm after
some cleanups, I think.)

I would like to make sure what is necessary.

Thanks.

-- 
Yasunori Goto 


