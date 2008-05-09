Return-Path: <linux-kernel-owner+w=401wt.eu-S1760169AbYEIXON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169AbYEIXON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 19:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbYEIXNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 19:13:55 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:53782 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344AbYEIXNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 19:13:54 -0400
Message-ID: <4824DAB0.8060604@krogh.cc>
Date: Sat, 10 May 2008 01:13:52 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Rick Jones <rick.jones2@hp.com>
CC: David Miller <davem@davemloft.net>, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
References: <86802c440805071130m62c1f4edydb3316dac4a2aba2@mail.gmail.com>	<20080507.141521.193714938.davem@davemloft.net>	<482498D5.9060008@krogh.cc>	<20080509.143229.174354251.davem@davemloft.net>	<4824C936.9000103@krogh.cc> <4824CE43.8060203@hp.com> <4824D4C0.10201@krogh.cc> <4824D830.9090504@hp.com>
In-Reply-To: <4824D830.9090504@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rick Jones wrote:
>>> To which cpu(s) were the neptune's interrupts assigned? (grep <ethN> 
>>> /proc/interrupts)
>>
>> Several
> 
> Which ones?-)  I suspect that since it is several that at least answers 
> the MSI_X question right?  Or is it possible to have a single device 
> have several MSI interrupts?

The table is rather large.
http://rafb.net/p/a9zfFA59.html


>>> Have you tried any tests without any filesystem involvement? 
>>
>> no not yet. I'll try that.
> 
> If you decide to go the netperf route, feel free to contact me directly 
> with netperf questions, or via the netperf-talk mailling list on 
> netperf.org.

Ok.

-- 
Jesper

