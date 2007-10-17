Return-Path: <linux-kernel-owner+w=401wt.eu-S935733AbXJQQLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935733AbXJQQLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 12:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757430AbXJQQKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 12:10:53 -0400
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:47551 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757353AbXJQQKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 12:10:52 -0400
To: Yi Yang <yang.y.yi@gmail.com>
Subject: Re: [PATCH 2.6.23] SysRq: print hotkey info while pressing undef key,  try 2
Cc: akpm@osdl.org, crutcher+kernel@datastacks.com,
       linux-kernel@vger.kernel.org, mj@atrey.karlin.mff.cuni.cz, pavel@ucw.cz,
       schwab@suse.de
In-reply-To: <471628D2.8010903@gmail.com>
References: <471628D2.8010903@gmail.com>
Message-Id: <E1IiBTu-0007cr-3i@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Wed, 17 Oct 2007 18:10:50 +0200
X-OriginalArrivalTime: 17 Oct 2007 16:10:50.0341 (UTC) FILETIME=[48FA6950:01C810D8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yi Yang wrote:
> Hot Key    Function Description
> =======    ====================
>    0       Changing Loglevel to this value
>    1       Changing Loglevel to this value
>    2       Changing Loglevel to this value
>    3       Changing Loglevel to this value
>    4       Changing Loglevel to this value
>    5       Changing Loglevel to this value
>    6       Changing Loglevel to this value
>    7       Changing Loglevel to this value
>    8       Changing Loglevel to this value
>    9       Changing Loglevel to this value

Wouldn't "Change Loglevel to this value" be more consistent with other
descriptions?
Or maybe even "Change Kernel Loglevel to <value>"; the repeated "this
value" seems somewhat silly.

>    b       Resetting

This is not very descriptive. Maybe "Immediate System Reboot"?

>    c       Trigger a crashdump

Most descriptions are capitalized. So for consistency this should be
"Trigger a Crashdump". (Although my personal preference would be to drop
the capitalization for all descriptions.)

>    p       Show Regs

Should "Regs" be expanded to "Registers"?

>   r       Keyboard mode set to XLATE

For consistency: "Set Keyboard Mode to XLATE"

Cheers,
Frans Pop
