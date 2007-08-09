Return-Path: <linux-kernel-owner+w=401wt.eu-S966248AbXHIQpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966248AbXHIQpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765949AbXHIQpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:45:24 -0400
Received: from mithrandir.softwarenexus.net ([66.98.186.96]:4974 "EHLO
	mail.genesi-usa.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761550AbXHIQpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:45:23 -0400
Message-ID: <46BB44E6.4050308@genesi-usa.com>
Date: Thu, 09 Aug 2007 17:46:30 +0100
From: Matt Sealey <matt@genesi-usa.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, Alan Curry <pacman@TheWorld.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: Pegasos keyboard detection
References: <200708020440.l724edCT290676@shell01.TheWorld.com> <46B79562.9020202@genesi-usa.com> <f4545a576abeddf00f076a0cae9e3fdd@kernel.crashing.org> <46B89C10.7090507@genesi-usa.com> <909c5e405e5cd26bca3aff13fe55adbc@kernel.crashing.org>
In-Reply-To: <909c5e405e5cd26bca3aff13fe55adbc@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Segher Boessenkool wrote:
>> Would you guys rather we shipped a boot script that ran the OS, fixed
>> all these issues in-place in-firmware, so Linux did not have to have 
>> these
>> workarounds,
> 
> Sure, if you can do that, that would be great.

Right, so don't accept that keyboard fix, and we will work on the script
instead.

-- 
Matt Sealey <matt@genesi-usa.com>
Genesi, Manager, Developer Relations
