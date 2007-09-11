Return-Path: <linux-kernel-owner+w=401wt.eu-S1760945AbXIKVuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945AbXIKVuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933072AbXIKVuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:50:03 -0400
Received: from tim.rpsys.net ([194.106.48.114]:37663 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757836AbXIKVuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:50:00 -0400
X-Greylist: delayed 1127 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Sep 2007 17:49:59 EDT
Subject: Re: [PATCH] leds: add #include <linux/spinlock_types.h> to
	include/linux/leds.h for rwlock_t
From: Richard Purdie <rpurdie@rpsys.net>
To: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070911174804.2c4949a7.yoichi_yuasa@tripeaks.co.jp>
References: <20070904162345.30e82bc8.yoichi_yuasa@tripeaks.co.jp>
	 <20070910220423.43e0a4d9.akpm@linux-foundation.org>
	 <20070911174804.2c4949a7.yoichi_yuasa@tripeaks.co.jp>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 22:30:47 +0100
Message-Id: <1189546247.6163.68.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 17:48 +0900, Yoichi Yuasa wrote:
> This patch has added #include <linux/spinlock.h> to include/linux/leds.h for rwlock_t.
> 
> Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

Added to the leds tree[1], thanks.

http://git.o-hand.com/?p=linux-rpurdie-leds;a=shortlog;h=for-mm

Richard

