Return-Path: <linux-kernel-owner+w=401wt.eu-S933309AbYD1KH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309AbYD1KH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 06:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbYD1KHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 06:07:19 -0400
Received: from trillian.zoopnet.de ([85.214.111.199]:51220 "EHLO
	trillian.zoopnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbYD1KHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 06:07:18 -0400
Message-ID: <4815A1D4.8000204@zoopnet.de>
Date: Mon, 28 Apr 2008 12:07:16 +0200
From: Mika Fischer <mika.fischer@zoopnet.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, balajirrao@gmail.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
References: <200801192045.17291.yinghai.lu@sun.com>	 <200801202256.48365.yinghai.lu@sun.com>	 <20080122165125.GA17992@elte.hu>	 <200801221623.20861.yinghai.lu@sun.com>	 <20080426035614.a30afb17.akpm@linux-foundation.org>	 <48132665.8050202@googlemail.com>	 <86802c440804272344yac6a9f0n40809169424247e6@mail.gmail.com>	 <48159668.5010808@googlemail.com> <86802c440804280234y5b38b4bds330fc1a6987202c5@mail.gmail.com> <48159ECF.9020004@googlemail.com> <4815A0D7.9030403@googlemail.com>
In-Reply-To: <4815A0D7.9030403@googlemail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C schrieb:
> BTW I just saw , there is this warning now :
> 
> [    0.305539] mtrr: your CPUs had inconsistent variable MTRR settings
> [    0.305546] mtrr: probably your BIOS does not setup all CPUs.
> [    0.305553] mtrr: corrected configuration.
> 
> but everything seems to work fine.

Just, FYI, I got this warning too. I didn't get it before applying the patch.

Regards,
 Mika
