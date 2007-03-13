Return-Path: <linux-kernel-owner+w=401wt.eu-S933295AbXCMNf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295AbXCMNf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 09:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933318AbXCMNf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 09:35:27 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:1123 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933295AbXCMNf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 09:35:27 -0400
Message-ID: <45F6A89C.50406@rtr.ca>
Date: Tue, 13 Mar 2007 09:35:24 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Marcel Holtmann <marcel@holtmann.org>,
       maxk@qualcomm.com, bluez-devel@lists.sourceforge.net
Subject: Re: [2/6] 2.6.21-rc3: known regressions
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>	<20070313125003.GS18731@stusta.de> <20070313143034.77425af4@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070313143034.77425af4@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Tue, 13 Mar 2007 13:50:03 +0100,
> Adrian Bunk <bunk@stusta.de> wrote:
> 
>> Subject    : ThinkPad X60: bluetooth hardlocks
>> References : http://lkml.org/lkml/2007/3/2/85
>> Submitter  : Pavel Machek <pavel@ucw.cz>
>> Handled-By : Marcel Holtmann <marcel@holtmann.org>
>> Status     : unknown
> 
> Does this still happen with -rc3? I'd have thought Mark's patch in
> 0de1517e23c2e28d58a6344b97a120596ea200bb fixed that...

Pavel?  Could you retest this now on a ThinkPad X60 ?

???
