Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbYGHNP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbYGHNP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 09:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbYGHNPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 09:15:46 -0400
Received: from lucidpixels.com ([75.144.35.66]:36794 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbYGHNPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 09:15:46 -0400
Date: Tue, 8 Jul 2008 09:15:45 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Gerhard Wiesinger <lists@wiesinger.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
In-Reply-To: <alpine.LFD.1.10.0807081232350.32659@bbs.intern>
Message-ID: <alpine.DEB.1.10.0807080915040.23688@p34.internal.lan>
References: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan> <alpine.LFD.1.10.0807071649340.1160@bbs.intern> <alpine.LFD.1.10.0807071705490.2997@bbs.intern> <alpine.DEB.1.10.0807071149530.32508@p34.internal.lan> <alpine.LFD.1.10.0807080811560.5439@bbs.intern>
 <alpine.DEB.1.10.0807080433550.17980@p34.internal.lan> <alpine.LFD.1.10.0807081232350.32659@bbs.intern>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Jul 2008, Gerhard Wiesinger wrote:

> On Tue, 8 Jul 2008, Justin Piszcz wrote:
>
>> 
>> 
>> On Tue, 8 Jul 2008, Gerhard Wiesinger wrote:
>> 
>>> On Mon, 7 Jul 2008, Justin Piszcz wrote:
>>> 
>>>> Hi Gerhard,
>> 
>> Please run:
>> 
>> smartctl -t short /dev/sdc
>> sleep 300
>> smartctl -t long /dev/sdc
>> 
>> Wait 2-3 hours or more and:
>> 
>> smartctl -a /dev/sdc
>
>
> I'm changing the disk one more time ...

Once you replace the disk please re-run the tests shown above and show us 
the output please.

How many SAMSUNG disks have you gone through, do they really fail that 
often?

Justin.
