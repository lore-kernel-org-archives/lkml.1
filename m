Return-Path: <linux-kernel-owner+w=401wt.eu-S1752282Ab0AYBsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab0AYBsP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 20:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967Ab0AYBsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 20:48:14 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60949 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab0AYBsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 20:48:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Roman Jarosz" <kedgedev@gmail.com>
Subject: Re: OOM-Killer kills too much with 2.6.32.2
Cc: kosaki.motohiro@jp.fujitsu.com, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <op.u6ixswy6asvm2a@kedge>
References: <op.u6ixswy6asvm2a@kedge>
Message-Id: <20100125104728.4935.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 25 Jan 2010 10:48:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> since kernel 2.6.32.2 (also tried 2.6.32.3) I get a lot of oom-killer  
> kills when I do hard disk intensive tasks (mainly in VirtualBox which is  
> running Windows XP) and IMHO it kills processes even if I have a lot of  
> free memory.
> 
> Is this a known bug? I have self compiled kernel so I can try patches.

Can you please post your .config?



