Return-Path: <linux-kernel-owner+w=401wt.eu-S969978AbXFHRVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969978AbXFHRVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 13:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761750AbXFHRVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 13:21:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761948AbXFHRVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 13:21:07 -0400
Message-ID: <46698FFC.40505@redhat.com>
Date: Fri, 08 Jun 2007 13:21:00 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc4-mm1
References: <1181206091.3625.9.camel@lov.localdomain>	 <4667D2DF.30207@googlemail.com> <1181228660.3625.23.camel@lov.localdomain>	 <46682385.1060802@redhat.com> <20070607154342.GA16911@suse.de>	 <20070607085200.f8d6e2d3.akpm@linux-foundation.org>	 <20070607155953.GA17591@suse.de>	 <20070607090632.cfcf02e6.akpm@linux-foundation.org>	 <20070607161525.GA18363@suse.de>	 <20070608003118.b8334635.akpm@linux-foundation.org>	 <20070608155139.GB7833@suse.de> <1181320585.3625.92.camel@lov.localdomain>
In-Reply-To: <1181320585.3625.92.camel@lov.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:

> Peter, any idea what it could be, that goes wrong on Andrew's box, or
> how to look for what exactly is going wrong?
>   http://userweb.kernel.org/~akpm/s5000552.jpg
> Seems that yellowdog uses RH's nash.

Yeah, but a /really/ old version -- 4.2.11 is from May 2005 :/ .  I feel 
I should point out that that version IS using udev, but just like 
mkinitrd and nash, the udev there is probably just as old.  At the same 
time, that does make it an excellent test case for this sort of situation.

Andrew, is there any chance you can put that initrd.img somewhere that I 
can download it?  That'd really help me to figure out what's going on, 
as the minutia of our initrds from 2005 have faded a bit in my memory.

-- 
   Peter
