Return-Path: <linux-kernel-owner+w=401wt.eu-S934155AbXEPUIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934155AbXEPUIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933020AbXEPUHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:07:06 -0400
Received: from smtp111.iad.emailsrvr.com ([207.97.245.111]:59917 "EHLO
	smtp111.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763244AbXEPUHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:07:02 -0400
Message-ID: <464B63D8.2060501@gentoo.org>
Date: Wed, 16 May 2007 16:04:40 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Duane Griffin <duaneg@dghda.com>
CC: Prakash Punnoor <prakash@punnoor.de>,
       Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>,
       LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Kconfig powernow-k8 driver should depend on ACPI P-States
 driver
References: <20070516011711.GE15763@ifa.hawaii.edu>	 <200705162039.02379.prakash@punnoor.de> <e9e943910705161253i75750876s1789b7844c87e97@mail.gmail.com>
In-Reply-To: <e9e943910705161253i75750876s1789b7844c87e97@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Duane Griffin wrote:
> On 16/05/07, Prakash Punnoor <prakash@punnoor.de> wrote:
>> Maybe you want to give a hint in the p states driver help text?
> 
> I think a hint is the right thing to do, but in the PowerNow! driver
> rather than the p states one. How about adding something like this to
> the X86_POWERNOW_K8 (and X86_POWERNOW_K7?) help text:

Please hold off this patch until we've gained a more complete 
understanding of the issues and workarounds (which will probably lead to 
us writing a better patch anyway)

Daniel

