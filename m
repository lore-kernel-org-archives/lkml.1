Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYH0HRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYH0HRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 03:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbYH0HRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 03:17:34 -0400
Received: from smtp.nokia.com ([192.100.122.230]:45810 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbYH0HRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 03:17:33 -0400
Message-ID: <48B4FD5E.8000103@yandex.ru>
Date: Wed, 27 Aug 2008 10:08:14 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ricard Wanderlof <ricard.wanderlof@axis.com>
CC: David Woodhouse <dwmw2@infradead.org>, Tim Anderson <tanderson@mvista.com>,
       "linux-mtd-bounces@lists.infradead.org" 
	<linux-mtd-bounces@lists.infradead.org>,
       "'Bruce Leonard'" <brucle@earthlink.net>,
       "Bruce_Leonard@selinc.com" <Bruce_Leonard@selinc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
References: <000201c9080d$0bce0d20$6b01a8c0@mvista.com> <1219818923.7107.106.camel@pmac.infradead.org> <Pine.LNX.4.64.0808270847350.17432@lnxricardw.se.axis.com>
In-Reply-To: <Pine.LNX.4.64.0808270847350.17432@lnxricardw.se.axis.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Aug 2008 07:11:19.0743 (UTC) FILETIME=[1AB864F0:01C90814]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ricard Wanderlof wrote:
>> I'm not sure I'd say I _vetoed_ new ioctls, but I certainly expressed a
>> desire to do all the information stuff through sysfs. We would need a
>> new MEMERASE64 ioctl though.
> 
> If the (lack of) sysfs stuff is standing between us and a nice >4GiB mtd 
> I for one would think that a set of 64-bit ioctls would be a reasonable 
> halfway house.

On the other hand we'll stay with half-solutions forever if we allow them.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
