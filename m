Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbZHCNUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbZHCNUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 09:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZHCNUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 09:20:06 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:55782 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755076AbZHCNUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 09:20:05 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-IronPort-AV: E=Sophos;i="4.43,314,1246831200";   d="scan'208";a="21329232"
Message-id: <4A76E3E8.30902@nets.rwth-aachen.de>
Date: Mon, 03 Aug 2009 15:19:36 +0200
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
To: q-funk@iki.fi
Cc: linux-kernel@vger.kernel.org
Subject: Re: x86 Geode issues in kernel >= 2.6.23 and >= 2.6.31-rc4
References: <11fae7c70908030558r28773beatd1dca702d490a57d@mail.gmail.com>
In-reply-to: <11fae7c70908030558r28773beatd1dca702d490a57d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin-Éric Racine wrote:
> (non-subscriber post; please keep me in CC)
> 
> Greetings,
> 
> Having previously reported two issues via Ubuntu's bug tracker and not
> found any answer, I thought I'd approach the LKML with the issues at
> stake.
> 
> 1) Since kernel 2.6.23, one cannot boot hardware based on the Geode
> SCx200 series. Partial answers about the most plausible cause have
> been found by the target hardware's manufacturer as explained at
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/241307
> 
> 2) Since kernel 2.6.31-rc4, one cannot boot hardware based on the
> Geode LX800 as described at
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/396286
> 
> In case either of these issues was already reported and there is a
> know fix or work-around, I'd love to hear more. Otherwise, please feel
> free to contact me for additional details.
> 

Just to give a data point:
2.6.31-rc1,2,3,4,5 were/are running all fine on my Geode LX800
(http://www.pcengines.ch/alix2d2.htm) so it seems something
board or .config specific.

Best regards,
Arnd

