Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbYLMCMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbYLMCMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 21:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbYLMCM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 21:12:26 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:26935 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbYLMCMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 21:12:25 -0500
Message-ID: <494319FC.1040908@oracle.com>
Date: Fri, 12 Dec 2008 18:12:12 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm <akpm@linux-foundation.org>
Subject: Re: mmotm 2008-12-11-19-42 uploaded (watchdog lib?)
References: <200812120345.mBC3jSnt017980@imap1.linux-foundation.org>
In-Reply-To: <200812120345.mBC3jSnt017980@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.494319FD.0132:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2008-12-11-19-42 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.28-rc8:


All of my mmotm-2008-1211-1942 builds end with:

kernel/time/clocksource.c:108: error: too few arguments to function 'watchdog->read'
kernel/time/clocksource.c:113: error: too few arguments to function 'cs->read'
kernel/time/clocksource.c:173: error: too few arguments to function 'watchdog->read'
kernel/time/clocksource.c:194: error: too few arguments to function 'watchdog->read'
make[3]: *** [kernel/time/clocksource.o] Error


~Randy

