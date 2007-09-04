Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbXIDRCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbXIDRCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 13:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbXIDRCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 13:02:05 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:41826 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752624AbXIDRCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 13:02:04 -0400
Message-ID: <46DD8F89.1060705@grupopie.com>
Date: Tue, 04 Sep 2007 18:02:01 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kernel panic with 2.6.23-rc5
References: <46DD6320.9080103@grupopie.com> <46DD6ACE.8050903@imap.cc>
In-Reply-To: <46DD6ACE.8050903@imap.cc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Paulo Marques schrieb:
>> I just tried booting a brand new 2.6.23-rc5 and after a few minutes it 
>> just panicked: machine totally frozen, blinking keyboard leds.
> [...]
>> Maybe someone out there has a good suggestion that I could try before 
>> bisecting...
> 
> A probable candidate would be:
> 
> http://lkml.org/lkml/2007/9/2/219

I've been running with that patch applied for a few hours now and 
everything seems to be working fine. Without the patch the kernel would 
hang in a few minutes, so I guess this fixed it.

Thanks for the help,

-- 
Paulo Marques - www.grupopie.com

"The Computer made me do it."
