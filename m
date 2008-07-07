Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbYGGRwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbYGGRwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYGGRwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:52:24 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:46234 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbYGGRwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:52:23 -0400
Message-ID: <487257D0.2030006@hp.com>
Date: Mon, 07 Jul 2008 10:52:16 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: alan@lxorguk.ukuu.org.uk, jeff@garzik.org, dwmw2@infradead.org,
       andi@firstfloor.org, tytso@mit.edu, hugh@veritas.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       mchan@broadcom.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
References: <1215178035.10393.763.camel@pmac.infradead.org>	<486E2818.1060003@garzik.org>	<20080704142753.27848ff8@lxorguk.ukuu.org.uk> <20080704.134329.209642254.davem@davemloft.net>
In-Reply-To: <20080704.134329.209642254.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Date: Fri, 4 Jul 2008 14:27:53 +0100
> 
> 
>>There are good sound reasons for having a firmware tree, the fact tg3 is
>>a bit of dinosaur in this area doesn't make it wrong.
> 
> 
> And bnx2, and bnx2x, and e100's ucode (hope David caught that one!).
> 
> It isn't just tg3.

Ah bnx2 - it may be "fixed" now, but trying to install Debian Lenny on a 
system with "core" bnx2 driven interfaces has been "fun" for a while now 
thanks to the firmware being exiled.

rick jones
