Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbYCZIFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbYCZIFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 04:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbYCZIFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 04:05:33 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:14226 "EHLO
	mail.netone.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYCZIFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 04:05:31 -0400
Message-ID: <47EA03C8.8030806@netone.net.tr>
Date: Wed, 26 Mar 2008 10:05:28 +0200
From: Tarkan Erimer <tarkan@netone.net.tr>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: alex-lists-linux-kernel@yuriev.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Visible boot slowdown between 2.6.24.3 and 2.6.22.2
References: <20080326024829.GA20476@s1.yuriev.com>
In-Reply-To: <20080326024829.GA20476@s1.yuriev.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2008 08:03:36.0214 (UTC) FILETIME=[E4966360:01C88F17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alex-lists-linux-kernel@yuriev.com wrote:
> Hi,
> 	I saw a significant slowdown of a bootup time after 2.6.22.2 was
> upgraded to 2.6.24.3. Visibly I can see the issue when the boot process gets
> to running udev - now it sits for good minute or two. I can also visibly see
> a slowdown when I do "ps aux" under the new kernel vs. old one.
>
> This is a relatively old system - 500 Mhz P3 Celeron with 512M RAM.
>
> Any debugging suggestions are appreciated...
>   
It's the same for me,too. I tried 2.6.24.3 on my IBM R40, which has 1.4 
GHZ CPU, the boot process is very slow. I didn't run "ps aux". But, I'll 
try that out and let know.
