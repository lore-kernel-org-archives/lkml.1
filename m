Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbZFBMYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbZFBMYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 08:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbZFBMY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 08:24:29 -0400
Received: from guanin.uni-konstanz.de ([134.34.240.60]:58175 "EHLO
	guanin.uni-konstanz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbZFBMY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:24:28 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jun 2009 08:24:28 EDT
X-IronPort-AV: E=Sophos;i="4.41,291,1241395200"; 
   d="scan'208";a="81034537"
Message-ID: <4A2517AD.1080509@uni-konstanz.de>
Date: Tue, 02 Jun 2009 14:14:37 +0200
From: Kay Diederichs <kay.diederichs@uni-konstanz.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090327)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Markus <M4rkusXXL@web.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Seagate Barracuda 7200.11 ST31500341AS fw SD17
References: <200906021258.20346.M4rkusXXL@web.de> <4A250B6A.6030904@grupopie.com> <200906021337.03123.M4rkusXXL@web.de>
In-Reply-To: <200906021337.03123.M4rkusXXL@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus schrieb:
> Rui Santos wrote:
>>> I have some Seagate Barracuda 7200.11 ST31500341AS 1.5TB drives. They 
>>> use the firmware SD17.
>> Seagate recommends firmware SD1A for that HD.
>> However, I do not know if it will solve your problem. Jut try it...
> 
>>> This drive+fw is blacklisted in the kernel, but there is no firmware 
>>> upgrade for these drives. (Only very few serial numbers are able to 
>>> upgrade.)
> 
> I cant upgrade the firmware because the flash-utility will abort due 
> to "not affected serial number". I tried SD1B, the very newest version.
> Cant find the SD1A for my drives.
> 
> Markus

I think you might have tried the wrong firmware file.
ST31500341AS needs 
http://www.seagate.com/staticfiles/support/downloads/firmware/Brinks-4D8H-SD1B.ISO

HTH,

Kay

