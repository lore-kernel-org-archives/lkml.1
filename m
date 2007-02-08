Return-Path: <linux-kernel-owner+w=401wt.eu-S1422680AbXBHXiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422680AbXBHXiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 18:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422636AbXBHXiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:38:13 -0500
Received: from lucidpixels.com ([75.144.35.66]:53006 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422680AbXBHXiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:38:12 -0500
Date: Thu, 8 Feb 2007 18:38:11 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: finger @finger.kernel.org -> Connection refused
In-Reply-To: <Pine.LNX.4.61.0702090036030.24888@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0702081837390.11265@p34.internal.lan>
References: <Pine.LNX.4.64.0702081826260.11265@p34.internal.lan>
 <Pine.LNX.4.61.0702090036030.24888@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Feb 2007, Jan Engelhardt wrote:

>
>> It appears to have been dead for awhile now, did I miss something?
>> One of my scripts uses this functionality, which now appears
>> dead/disabled/offline.
>>
>> Can anyone provide an update?
>
> kernel.org front page sayz:
>
> Aug 21, 2003: Please don't use finger.kernel.org for any sort of
> automatic monitoring. The number of automatic bots hitting this port is
> causing the finger daemon to shut down more often than not. The same
> information is available from http://www.kernel.org/kdist/finger_banner.
>
> ;-)
>
>
> Jan
> -- 
> ft: http://freshmeat.net/p/chaostables/
>

Thanks!

$ wget -q -O- http://www.kernel.org/kdist/finger_banner
The latest stable version of the Linux kernel is:           2.6.20
The latest snapshot for the stable Linux kernel tree is:    2.6.20-git1
The latest 2.4 version of the Linux kernel is:              2.4.34.1
The latest 2.2 version of the Linux kernel is:              2.2.26
The latest prepatch for the 2.2 Linux kernel tree is:       2.2.27-rc2
The latest -mm patch to the stable Linux kernels is:        2.6.20-rc6-mm3

Wget it is.

Justin.

