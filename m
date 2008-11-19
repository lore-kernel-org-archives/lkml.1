Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129AbYKSXlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbYKSXlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 18:41:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYKSXkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 18:40:55 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:16840 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbYKSXky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 18:40:54 -0500
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>, Bernhard Walle <bwalle@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
Date: Wed, 19 Nov 2008 23:39:04 +0000
Subject: RE: [PATCH] [WATCHDOG] [hpwdt] Set the mapped BIOS address space as
 executable
Thread-Topic: [PATCH] [WATCHDOG] [hpwdt] Set the mapped BIOS address space
 as executable
Thread-Index: AclKnCc+mcdpZunbQVSNSasmUNFkSAAA9B+Q
Message-ID: <183C1D5A376DE343AA8F94FC2A1EC1493AA5D6987F@GVW1091EXB.americas.hpqcorp.net>
References: <1226674023-5374-1-git-send-email-bwalle@suse.de>
 <20081118143015.72af31d3.akpm@linux-foundation.org>
 <20081118233229.294270fb@kopernikus.site>
 <183C1D5A376DE343AA8F94FC2A1EC1493AA5CEE7AB@GVW1091EXB.americas.hpqcorp.net>
 <20081119093041.1af8fd7e.akpm@linux-foundation.org>
 <20081119183444.56b342cb@hale.suse.de>
 <20081119230014.GC30873@infomag.infomag.iguana.be>
 <20081120000215.45071a50@kopernikus.site>
 <20081119231124.GD30873@infomag.infomag.iguana.be>
In-Reply-To: <20081119231124.GD30873@infomag.infomag.iguana.be>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tested changing the return value to NOTIFY_OK always.

-----Original Message-----
From: Wim Van Sebroeck [mailto:wim@iguana.be]
Sent: Wednesday, November 19, 2008 5:11 PM
To: Bernhard Walle; Mingarelli, Thomas
Cc: Andrew Morton; linux-kernel@vger.kernel.org; stable@kernel.org
Subject: Re: [PATCH] [WATCHDOG] [hpwdt] Set the mapped BIOS address space as executable

Hi Bernhard,

> Wasn't the conclusion that NOTIFY_OK always works and we should not
> rely on that 'allow_kdump' option?

Wasn't completely clear to me, but it would indeed be much cleaner.

Hi Tom,

What did you test exactly?

Thanks in advance,
Wim.

