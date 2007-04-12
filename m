Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbXDLBCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbXDLBCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 21:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbXDLBCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 21:02:21 -0400
Received: from [202.78.101.198] ([202.78.101.198]:45506 "EHLO mail.hq.astra.ph"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753778AbXDLBCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 21:02:20 -0400
Message-ID: <461D84EB.7040207@gmail.com>
Date: Thu, 12 Apr 2007 09:01:31 +0800
From: Carlo Florendo <subscribermail@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "menu" versus "menuconfig" -- they're *both* a bad idea
References: <Pine.LNX.4.64.0704110357200.9384@CPE00045a9c397f-CM001225dbafb6> <Pine.LNX.4.61.0704111059190.32056@yvahk01.tjqt.qr> <Pine.LNX.4.64.0704110509200.11343@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0704110509200.11343@CPE00045a9c397f-CM001225dbafb6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>   (in short, if i, the builder, explicitly choose *not* to add a
> certain feature to my build, i think i have every right to expect that
> some other part of my configuration isn't quietly going to put some
> sub-choice of that feature back in behind my back.)

I agree with this.  However, if another feature actually depends on another 
explicitly unselected feature, there should at least be a warning prompt 
that such is the case.

It probably would be hard though to track all dependencies.

Best Regards,

Carlo


-- 
Carlo Florendo
Softare Engineer/Network Co-Administrator
Astra Philippines Inc.
UP-Ayala Technopark, Diliman 1101, Quezon City
Philippines
http://www.astra.ph

--
The Astra Group of Companies
5-3-11 Sekido, Tama City
Tokyo 206-0011, Japan
http://www.astra.co.jp
