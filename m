Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab0CEK4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 05:56:50 -0500
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:59414 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab0CEK4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 05:56:49 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B90E3EE.20604@jic23.retrosnub.co.uk>
Date: Fri, 05 Mar 2010 10:58:54 +0000
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
References: <4B8C1867.7040201@cam.ac.uk> <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com> <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain> <20100303184132.GA11471@core.coreip.homeip.net> <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain> <20100303190753.GB11471@core.coreip.homeip.net> <4B8EB99F.4080104@jic23.retrosnub.co.uk> <20100305073850.GA20980@matterhorn.verdurent.com>
In-Reply-To: <20100305073850.GA20980@matterhorn.verdurent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/10 07:38, Amit Kucheria wrote:
> On 10 Mar 03, Jonathan Cameron wrote:
>>>
>>> I was hoping IIO would fill the niche of framework for generic data
>>> acquisition devices, regardless of how fast or slow they are.
>> We are working on it, but unfortunately the 'fast' end of the scale is
>> making it rather complex beast and there is still a fair bit of work
>> to be done before we suggest merging into the main tree.  We allow
>> for 'simple' drivers that do have very similar functionality to ALS as
>> proposed. (i.e. they just handle some sysfs interfaces and device
>> registration).
>>
>> I certainly have no objection to taking light sensors back into IIO.
>> (one never moved out!)  Obviously I'll want opinions from the individual
> 
> I suspect you are pointing to the tsl2563 driver here. It's rework (iio->als)
> has been languishing in my tasklist for a couple of months now. I haven't had
> time for testing.
> 
> I guess I'll wait some more to see where this discussion goes.
> 
Very wise!
