Return-Path: <linux-kernel-owner+w=401wt.eu-S933153AbYCFLX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153AbYCFLX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761811AbYCFLXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:23:18 -0500
Received: from smtp-out4.blueyonder.co.uk ([195.188.213.7]:34696 "EHLO
	smtp-out4.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754119AbYCFLXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:23:16 -0500
Message-ID: <47CFD421.4000108@Keehan.net>
Date: Thu, 06 Mar 2008 11:23:13 +0000
From: Mike Keehan <Mike@Keehan.net>
Reply-To: Mike@Keehan.net
User-Agent: Thunderbird 3.0a1pre (X11/2008030503)
MIME-Version: 1.0
To: Harald Dunkel <harald.dunkel@t-online.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: strange behavior on multimedia eject button for cdrom
References: <47C15020.8040806@t-online.de> <47C7FECD.3040205@Keehan.net> <47CB11FA.60008@t-online.de> <47CC5C47.8050604@Keehan.net> <47CC712F.6040601@t-online.de>
In-Reply-To: <47CC712F.6040601@t-online.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Dunkel wrote:
> Hi Mike,
>
> Mike Keehan wrote:
>>
>> Hi again.
>>
>> Ok, I just tried doing the same thing on my M1330. It behaves
>> differently to yours in that a small section of music repeats again
>> and again until the disk is ejected, and then carries on (I was using
>> RealPlayer with a local file as a simple test).
>>
>> And it does look like other things stop working while the disk is
>> ejected - screen updates freeze and network too I think.
>>
>
> Thats exactly what I see, too.
>
>
> Regards
>
> Harri
>

Hi Harri.

I've just tried ejecting a CD when the Grub boot menu was counting 
down, and even that froze until the CD was ejected and the drive motor 
noises had stopped.  Grub continued the countdown, and then Linux 
booted OK.

So I think it is a hardware issue with this laptop.

Mike.

