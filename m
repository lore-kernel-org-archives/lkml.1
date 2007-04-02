Return-Path: <linux-kernel-owner+w=401wt.eu-S933948AbXDBGwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948AbXDBGwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 02:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933955AbXDBGwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 02:52:08 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:32904 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933948AbXDBGwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 02:52:05 -0400
Date: Mon, 2 Apr 2007 08:51:44 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/16] warn-on-kthread-name-truncation.diff
In-Reply-To: <20070401230041.adb1647a.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0704020848220.1245@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704012011430.12316@yvahk01.tjqt.qr>
 <20070401230041.adb1647a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 1 2007 23:00, Andrew Morton wrote:
>On Sun, 1 Apr 2007 20:18:22 +0200 (MEST) Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>
>I'm not sure that it's a big enough problem to go adding code for, really.

No, not really. If there are any kthread spawners that do exceed the limit,
I would have probably gotten a message by now over the last handful of kernel
releases. So everything seems clear.


Jan
-- 
