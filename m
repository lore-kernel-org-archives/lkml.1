Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbYBFKyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbYBFKyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 05:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761072AbYBFKx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 05:53:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:16788 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758811AbYBFKxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 05:53:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=xE50NIobU5ivQ68zA49InIXwEud7GYrmiBcL1K5L1HenAds4kALufEEDV6LJ/TGAabj0MUuaUcF43VyeAsDeBQ3ybP5uXsGZTkhMb23x/T3EPsNcEFuAT7HPtPb5NC3StwW/MWZy+NSgqdMIigQRgkyeLdLotq4j9LMHlnH9sYo=
Message-ID: <47A991BE.9030705@gmail.com>
Date: Wed, 06 Feb 2008 11:53:50 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org,
       ath5k-devel@lists.ath5k.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-wireless@vger.kernel.org
Subject: Re: [RFT 1/1] single_chip test
References: <20080206014131.9d489a34.akpm@linux-foundation.org>	<1202294560-7313-1-git-send-email-jirislaby@gmail.com> <jezluetl7d.fsf@sykes.suse.de>
In-Reply-To: <jezluetl7d.fsf@sykes.suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2008 11:48 AM, Andreas Schwab wrote:
>> +	ah->ah_single_chip = !!(srev >= AR5K_SREV_VER_AR2424 &&
>                            ^^
> 
> This is useless.

Amended locally, thanks.
