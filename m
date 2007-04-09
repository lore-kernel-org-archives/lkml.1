Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbXDITiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbXDITiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 15:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbXDITiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 15:38:46 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:35311 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbXDITip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 15:38:45 -0400
Date: Mon, 09 Apr 2007 15:38:44 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: I give up
In-reply-to: <461A71FA.40900@zytor.com>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Jeff Garzik <jeff@garzik.org>
Message-id: <200704091538.44253.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704091007.58535.gene.heskett@gmail.com>
 <Pine.LNX.4.61.0704091848150.21426@yvahk01.tjqt.qr> <461A71FA.40900@zytor.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2007, H. Peter Anvin wrote:
>Jan Engelhardt wrote:
>> dm is on 254 for me.. in opensuse with a 2.6.20 that is. I wonder why
>> it even moves around. However, even then, those who use udev and
>> device names rather than (major,minor) tuples should not have any
>> problem.
>
>It moves around because someone at some point thought it was a great
>idea to assign dynamic majors to core functionality.
>
What were they smoking, I want some of that!

>It stays put at 254 for you since that's the highest (and thus
>first-used) dynamic major.
>
>	-hpa



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
<Culus> OH MY GOD NOT A RANDOM QUOTE GENERATOR
<netgod> surely you didnt think that was static? how lame would that 
be? :-)
