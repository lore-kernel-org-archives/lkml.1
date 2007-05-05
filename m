Return-Path: <linux-kernel-owner+w=401wt.eu-S1031729AbXEEEDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031729AbXEEEDX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 00:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031732AbXEEEDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 00:03:22 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:35650 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031729AbXEEEDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 00:03:22 -0400
Message-ID: <463C01FA.8070206@interia.pl>
Date: Sat, 05 May 2007 06:03:06 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: john stultz <johnstul@us.ibm.com>, davej@codemonkey.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk
Subject: Re: cpufreq longhaul locks up
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr> 	<1178311052.6094.0.camel@localhost.localdomain> 	<Pine.LNX.4.61.0705042259160.18504@yvahk01.tjqt.qr>	<1178318978.6094.29.camel@localhost.localdomain> <Pine.LNX.4.61.0705050130090.18504@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705050130090.18504@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-EMID: e6160acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Switching from acpi_pm+performance to acpi_pm+ondemand also
>>> locks up after a few minutes.
>> Yep. Sounds like an ondemand issue. Thanks for verifying this for me.
> 
> Nah, it also happens with cpufreq_powersave. I just need to check 
> through some archives and try booting with governor=powersave so that it 
> always stays low. 
You have a lockup when switching from other governor to powersave? Or if  
You are using it for some time?


----------------------------------------------------------------------
Wicie, rozumicie....
Zobacz >>> http://link.interia.pl/f1a74

