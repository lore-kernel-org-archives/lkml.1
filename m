Return-Path: <linux-kernel-owner+w=401wt.eu-S1760871AbXERKXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbXERKXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 06:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbXERKXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 06:23:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53010 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856AbXERKXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 06:23:35 -0400
Message-ID: <464D7EB4.1080102@anagramm.de>
Date: Fri, 18 May 2007 12:23:48 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Mike.Johnson@apc.com
CC: linux-kernel@vger.kernel.org
Subject: Re: question on msdos support
References: <OFC29C8BAB.491598A7-ON852572DE.007320AA-852572DE.0073CEA7@apcc.com>
In-Reply-To: <OFC29C8BAB.491598A7-ON852572DE.007320AA-852572DE.0073CEA7@apcc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX19FnZ89OXlDafKcuFLrFbSsA8duVUH1f+aVDS7
 g1GvBxqe6f4Jc6K1aI70GVCfZSFcbtBKyavV+n60CLnhHRjZy0
 njO2k+5AmGhvVLi9qX1pg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mike!

Mike.Johnson@apc.com schrieb:
> Whoever responds to this mail, please email me directly....thank-you!
> 
> It seems that the dos file system does not work correctly with kernel
> version 2.6.12. When using a dos formatted usb memory stick and placing
> files onto the memory stick, the files are corrupt.

Please define "dos file system". FAT32?
Works over here on 2.6.20.3

And did you should check your memory stick on a machine with some
newer kernel version or with a different format?

There are some more or less cheap memory sticks around which
are just crap!

> Any thoughts on patches that may have fixed this...or where I can go to
> search for patch information would be helpful

I would first try a newer kernel (well, you need to switch to
udev, if you haven't already(?)).

Greets,
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com
