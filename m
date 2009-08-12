Return-Path: <linux-kernel-owner+w=401wt.eu-S932424AbZHLJ63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbZHLJ63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932257AbZHLJ63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:58:29 -0400
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:42605 "EHLO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZHLJ62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:58:28 -0400
Message-ID: <4A829271.6000507@gefanuc.com>
Date: Wed, 12 Aug 2009 10:59:13 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
References: <20090810193849.GA3055@braap.org> <4A812BCE.3010003@gefanuc.com> <20090811144914.GB32658@braap.org> <4A8189D9.4080709@gefanuc.com> <20090811153633.GC32658@braap.org> <4A819130.5080802@gefanuc.com> <20090811154226.GD32658@braap.org> <4A819E80.90103@gefanuc.com> <20090811204835.GA9910@braap.org> <4A828395.9040006@gefanuc.com> <20090812095436.GC2604@braap.org>
In-Reply-To: <20090812095436.GC2604@braap.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emilio G. Cota wrote:
> Martyn Welch wrote:
>   
>> There is a further device situated between the two.
>>     
>>> How do you now protect the registers of this device from
>>>       
>>>> accidental/malicous/buggy behaviour from your board, since
>>>>         
>> this region of the VME bus is now enabled for transfers
>> in the PCI IO Mem space?
>>     
>
> The kernel is not designed to work with buggy hardware--that
> would be insane, we've got more than enough dealing with our
> own bugs. However when there's no other solution (e.g.
> hardware can't be fixed for whatever reason), fixes on a
> per-case basis may be applied.
>
>   
Apart from : not mapping regions of the VME bus that you are not using.

Martyn

> E.
>   


-- 
Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)1327322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189
