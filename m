Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbYIRWme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbYIRWme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 18:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbYIRWm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 18:42:26 -0400
Received: from xenotime.net ([66.160.160.81]:52737 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754968AbYIRWm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 18:42:26 -0400
Date: Thu, 18 Sep 2008 15:42:18 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org
Subject: Re: mmotm 2008-09-18-14-56 uploaded (olpc_battery build errors)
In-Reply-To: <200809182157.m8ILv0Vi021531@imap1.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0809181540480.28355@shark.he.net>
References: <200809182157.m8ILv0Vi021531@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008, akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-09-18-14-56 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.27-rc6:

olpc_battery build fails with

mmotm-2008-0918-1456/drivers/power/olpc_battery.c: At top level:
mmotm-2008-0918-1456/drivers/power/olpc_battery.c:363: error: unknown field 'owner' specified in initializer
mmotm-2008-0918-1456/drivers/power/olpc_battery.c:363: warning: excess elements in struct initializer
mmotm-2008-0918-1456/drivers/power/olpc_battery.c:363: warning: (near initialization for 'olpc_bat_eeprom.attr')
make[3]: *** [drivers/power/olpc_battery.o] Error 1


-- 
~Randy
