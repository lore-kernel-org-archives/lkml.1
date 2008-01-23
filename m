Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbYAWRef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbYAWRef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758123AbYAWRcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:32:00 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:42854 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758114AbYAWRb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:31:58 -0500
Message-ID: <47977A02.40506@freescale.com>
Date: Wed, 23 Jan 2008 11:31:46 -0600
From: Jon Loeliger <jdl@freescale.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Kumar Gala <galak@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 0/8] [POWERPC] 8xx cleanups
References: <4797641F.4000902@scram.de>	<CA8FFE19-B84A-426B-9B1C-EF0F7C87AE47@kernel.crashing.org> <20080123171252.GA22967@uranus.ravnborg.org>
In-Reply-To: <20080123171252.GA22967@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>> What impact do the have on boards in arch/ppc being able to build?
> 
> Byt the way what are the plans for powerpc?
> We have:
> arch/ppc
> arch/ppc64
> arch/powerpc
> 
> It was my understanding that arch/powerpc was supposed
> to be the future unified powerpc architecture but it
> does not even provide a defconfig.
> 
> And I do not see too much happening to do so - but that maybe
> because I looked at a wrong place.

You must have looked in the wrong place. :-)

arch/ppc is scheduled for removal from mainline in June.

arch/powerpc is under significant development, with lots
of defconfigs in arch/powerpc/configs.

arch/ppc64 is long dead.

jdl

