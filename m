Return-Path: <linux-kernel-owner+w=401wt.eu-S1759136AbYDAL2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136AbYDAL2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756965AbYDAL2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:28:07 -0400
Received: from smtp.nokia.com ([192.100.105.134]:40596 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760AbYDAL2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:28:06 -0400
Message-ID: <47F21B47.4000206@yandex.ru>
Date: Tue, 01 Apr 2008 14:23:51 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi, =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
       ext-adrian.hunter@nokia.com, jwboyer@gmail.com
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
References: <47F1EC20.6050600@wpkg.org> <47F1F644.4060000@yandex.ru> <878wzx25s7.fsf@basil.nowhere.org>
In-Reply-To: <878wzx25s7.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2008 11:27:43.0685 (UTC) FILETIME=[6720A750:01C893EB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Artem Bityutskiy <dedekind@yandex.ru> writes:
> 
>> Tomasz Chmielewski wrote:
>>> For me, the motivators to wait for LogFS are mainly the facts that it
>>> can work on traditional block devices, and not only on pure flash:
>> Sorry Thomasz, for me this makes zero sense. There are _much_ better file
>> systems for block devices.
> 
> I think he refers to flash disks appearing as block devices, like
> usb sticks or similar.

Right, I also meant that in my opinion it makes more sense to use traditional
file-systems like ext3 on USB-key/MMC and the like stuff (which I confusingly
referred as "block devices"), or may be something more "heavy-weight" like
XFS or JFS (never tried them, though).

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
