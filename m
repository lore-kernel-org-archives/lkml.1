Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbYGHKcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbYGHKcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 06:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYGHKck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 06:32:40 -0400
Received: from chello212186124096.11.vie.surfer.at ([212.186.124.96]:45754
	"EHLO wiesinger.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbYGHKci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 06:32:38 -0400
Date: Tue, 8 Jul 2008 12:31:50 +0200 (CEST)
From: Gerhard Wiesinger <lists@wiesinger.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
In-Reply-To: <alpine.DEB.1.10.0807080434470.17980@p34.internal.lan>
Message-ID: <alpine.LFD.1.10.0807081227460.32659@bbs.intern>
References: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan> <alpine.LFD.1.10.0807071649340.1160@bbs.intern> <alpine.LFD.1.10.0807071705490.2997@bbs.intern> <alpine.DEB.1.10.0807071149530.32508@p34.internal.lan> <alpine.LFD.1.10.0807080811560.5439@bbs.intern>
 <alpine.LFD.1.10.0807080857460.10532@bbs.intern> <alpine.DEB.1.10.0807080434470.17980@p34.internal.lan>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-MailScanner-Information-wiesinger.com: Please contact the ISP for more information
X-MailScanner-wiesinger.com: Found to be clean
X-MailScanner-SpamCheck-wiesinger.com: not spam, SpamAssassin (score=-4.399,
	required 4.5, autolearn=not spam, ALL_TRUSTED -1.80, BAYES_00 -2.60)
X-MailScanner-From: lists@wiesinger.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008, Justin Piszcz wrote:

>> BTW:
>> The error in syslog also accoured when Reallocated_Sector_Ct didn't go up.
>> 
>
> Yes, I have seen the same thing on drives going bad as well.
>
> What type of PSU are you using (per the other thread) and how are you 
> splitting the power connectors/etc?
>

I'm using an Enermax Power Supply (ATX 385 Watt, ENERMAX PRO82+) for 6 
harddisks using a connector with 2 connectors, and I think also 2 more 
with 2 connectors. But I'm currently not at the computer.

Ciao,
Gerhard

--
http://www.wiesinger.com/

