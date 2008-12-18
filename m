Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbYLRXPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbYLRXPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYLRXPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 18:15:13 -0500
Received: from mail.tmr.com ([64.65.253.246]:60124 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbYLRXPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 18:15:11 -0500
Message-ID: <494AD950.3030802@tmr.com>
Date: Thu, 18 Dec 2008 18:14:24 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081112 Fedora/1.1.13-1.fc9 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Redeeman <redeeman@metanurb.dk>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, xfs@oss.sgi.com,
       smartmontools-support@lists.sourceforge.net
Subject: Re: Have the velociraptors in a test system now, checkout the errors.
References: <alpine.DEB.1.10.0812060426280.3494@p34.internal.lan>  <49405A94.8080601@tmr.com> <1229225303.16555.149.camel@localhost> <4949645F.4030407@tmr.com> <alpine.DEB.1.10.0812171820200.26527@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0812171820200.26527@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
>>
>> Calls itself "WDC WD10EACS-00D" in /sys if that helps. I could dig 
>> out the packing slip if it matters. Runs nicely so far, and if the 
>> SMART temperature probe is correct, very cool:
>>
>> /dev/sda: ST3750640AS: 43 C
>> /dev/sdb: WDC WD10EACS-00D6B1: 31 C
>> /dev/sdc: ST3750640AS: 44 C
>> /dev/sdd: ST3750640AS: 46 C
>>
>> I don't totally trust the temps, there is a LOT of 18C air going into 
>> that box, because it has a lot coming out the back and side.
>
> Hmm do you have a picture of those seagates? Seems like a lack of 
> airflow there
> or do they just run really hot?  Also, how many head unload/loads has the
> 1.0TB GP drive performed, that was one of my concerns when I was 
> looking at
> disks.

How about a diagram:

__________________________________________________
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                 --empty--        |
                                 (seagate)        |
                                 (WD)             |
                                 (seagate)        | <--- case
                                 (seagate)        |
                                 --empty--        |
__________________________________________________|


That's about how the drives sit in the case, air vents are in the front 
of the case, fans in back pulling air out.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


