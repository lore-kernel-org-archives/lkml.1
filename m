Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbXHYFM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbXHYFM3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 01:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbXHYFMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 01:12:21 -0400
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:1630 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbXHYFMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 01:12:20 -0400
Message-ID: <46CFBA1C.80506@xs4all.nl>
Date: Sat, 25 Aug 2007 07:11:56 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-kernel@vger.kernel.org, mpm@selenic.com, mb@bu3sch.de
Subject: Re: possible BUG while doing gpg --gen-key
References: <46CF079C.7010304@xs4all.nl> <20070825011419.GL30705@stusta.de>
In-Reply-To: <20070825011419.GL30705@stusta.de>
X-Enigmail-Version: 0.95.3
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
>> FWIW: I run audio-entropyd and use netdev-random. Both pieces of
>> sofwtare don't interfere as far as I know.
> 
> 
> Can you try without both, and if it works, which of them causes the 
> problem?

I can try.

>> This is on a VIA Epia EK8000 again.
> 
> 
> Is CONFIG_HW_RANDOM_VIA enabled in your kernel?
> If yes, does disabling it help?

I only run rngd to get the random info from the CPu to the pool.
Stopping rngd is enough?
