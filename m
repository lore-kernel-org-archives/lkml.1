Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbXDPBXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbXDPBXO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 21:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbXDPBXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 21:23:14 -0400
Received: from mail.cavein.org ([66.245.249.51]:34321 "EHLO mail.cavein.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253AbXDPBXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 21:23:14 -0400
Date: Sun, 15 Apr 2007 18:23:09 -0700 (PDT)
From: Richard A Nelson <cowboy@cavein.org>
To: Jiri Slaby <jirislaby@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Subject: Re: 2.6.21-rc6, ASUS M2V 1.01G, ALSA detection/non-support
In-Reply-To: <46229CF9.3010609@gmail.com>
Message-ID: <alpine.DEB.0.98.0704151821120.12596@hygvzn-guhyr.pnirva.bet>
References: <alpine.DEB.0.98.0704151341250.12045@hygvzn-guhyr.pnirva.bet>
 <46229CF9.3010609@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Apr 2007, Jiri Slaby wrote:

> Date: Sun, 15 Apr 2007 23:45:29 +0200
> From: Jiri Slaby <jirislaby@gmail.com>
> To: Richard A Nelson <cowboy@cavein.org>
> Cc: linux-kernel <linux-kernel@vger.kernel.org>
> Subject: Re: 2.6.21-rc6, ASUS M2V 1.01G, ALSA detection/non-support
> 
> Cc: alsa-devel@alsa-project.org
>
> Richard A Nelson napsal(a):
>> My son has an earlier version of the M2V & BIOS (0901) and his gets full
>> 6ch
>> sound.
>>
>> The 1.01G, and related BIOS (1304 or 1701) do not properly handle the
>> onboard sound:
>> hda_codec: Unknown model for ALC660VD/ALC861VD, trying auto-probe from
>> BIOS...
>
> What does your /proc/asound/version say?

Both machines say:
Advanced Linux Sound Architecture Driver Version 1.0.14rc3 (Wed Mar 14 07:25:50 2007 UTC).

The machines are running Debian Sid

-- 
Rick Nelson
Life'll kill ya                         -- Warren Zevon
Then you'll be dead                     -- Life'll kill ya
