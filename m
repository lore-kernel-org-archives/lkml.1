Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbZHKMeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbZHKMeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZHKMeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:34:17 -0400
Received: from exprod5og114.obsmtp.com ([64.18.0.28]:56940 "EHLO
	exprod5og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbZHKMeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:34:17 -0400
Message-ID: <4A81224B.7030906@gefanuc.com>
Date: Tue, 11 Aug 2009 08:48:27 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: "Emilio G. Cota" <cota@braap.org>, Greg K-H <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
References: <20090803205657.964064732@mini.kroah.org> <20090803210111.GB28430@kroah.com> 	<20090808230145.GB27151@braap.org> <4A801644.2070009@gefanuc.com> <8bd0f97a0908102154t3b0f393bg941a16e2f14a03b7@mail.gmail.com>
In-Reply-To: <8bd0f97a0908102154t3b0f393bg941a16e2f14a03b7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Mon, Aug 10, 2009 at 08:44, Martyn Welch wrote:
>   
>> For using the VME bus for communication between two SBCs, I think we could
>> use the CRCSR space to provide some information about the resources used on
>> each board for say, a virtual network driver like the rapidIO subsystem
>> provides. Possibly using the "device tree" stuff used on PowerPC, Blackfin
>> and Sparc archs (I believe) for passing device layout between the firmware
>> and kernel at boot.
>>     
>
> Blackfin doesnt use device trees and there are no plans to do so
> -mike
>   
Sorry, my mistake, I thought it did.

Martyn

-- 
Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)1327322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189
