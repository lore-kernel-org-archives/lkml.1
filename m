Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbZFWT5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbZFWT5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbZFWT5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:57:44 -0400
Received: from mga05.intel.com ([192.55.52.89]:60762 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756015AbZFWT5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:57:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,277,1243839600"; 
   d="scan'208";a="701884950"
Message-ID: <4A4133B6.704@linux.intel.com>
Date: Tue, 23 Jun 2009 21:57:42 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend
 to 	disk, mce related?
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>	 <4A3EE668.5090400@jp.fujitsu.com>	 <8db1092f0906220019x1560c26dsd5a6daa3ea612ec@mail.gmail.com>	 <4A3F55C7.4030909@linux.intel.com>	 <8db1092f0906220453k5595998er1400567cbcdf3e12@mail.gmail.com>	 <4A3F7A93.5080004@linux.intel.com>	 <8db1092f0906220627w61d9f97g88c91f770f732f03@mail.gmail.com>	 <4A3F8BF7.6010406@linux.intel.com>	 <8db1092f0906220755v55699d5cj697b9bdf48978bd9@mail.gmail.com>	 <4A404EC6.8080902@jp.fujitsu.com> <8db1092f0906230747j1bcfe041r11bd0ffbeaa8e41a@mail.gmail.com>
In-Reply-To: <8db1092f0906230747j1bcfe041r11bd0ffbeaa8e41a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> 2009/6/23 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
> 
>> Maciej, could you try this patch?
> 
> Tested in 2 systems (for 17 and 30 minutes). Works without any
> problems. Thanks for patch!

Ok great. Thanks for testing. Peter please put Seto-san's patch into urgent.

Acked-by: Andi Kleen <ak@linux.intel.com>

Thanks.

-Andi
