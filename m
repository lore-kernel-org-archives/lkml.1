Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbYJGW2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbYJGW2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbYJGW20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:28:26 -0400
Received: from ishtar.tlinx.org ([64.81.245.74]:37327 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210AbYJGW20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:28:26 -0400
Message-ID: <48EBE263.8000500@tlinx.org>
Date: Tue, 07 Oct 2008 15:27:47 -0700
From: Linda Walsh <smartmontools@tlinx.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [smartmontools-support] inactive SATA drives won't stay in standby
 or sleep, PATA models did. (fwd)
References: <Pine.LNX.4.64.0809142159550.18213@gc.phys.uwm.edu> <48E1B8F8.3090205@gmail.com> <48E26BDA.8080804@tlinx.org> <48E26E61.2010705@gmail.com> <48E34BC8.3050009@tlinx.org> <48E6DE07.70706@gmail.com> <48EAAF2E.4060407@tlinx.org> <48EAB672.3010209@gmail.com> <48EABD07.6030506@tlinx.org> <48EABE8E.9070809@gmail.com>
In-Reply-To: <48EABE8E.9070809@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Linda Walsh wrote:
>   
>> Controller is a Promise TX4/300
>> Yeap.  After the drive goes offline, does unplugging and replugging
>> the power cable to the harddrive makes it come back?
>>     
----
    No.  It hangs the computer. about 2-3 seconds after plugging the
drives back in.  Did it twice to verify it wasn't a fluke.  Verified
drives removed from /dev, then
plugged them back in -- was able to do about 1-2 ls commands on /dev, then
keyboard goes dead.

    First time I tried unplugging the power cables and replugging --
that hung...
2nd time tried unplugging a sata cable and replugging -- that hung too.

    Hopefully you won't need any more tests of this exact nature...? :-)



