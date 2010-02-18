Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab0BRSEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:04:46 -0500
Received: from stinky.trash.net ([213.144.137.162]:37837 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab0BRSEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:04:42 -0500
Message-ID: <4B7D8135.9040100@trash.net>
Date: Thu, 18 Feb 2010 19:04:37 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, netfilter-devel@vger.kernel.org,
       Netdev <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for February 18 (netfilter)
References: <20100218204937.54a613d2.sfr@canb.auug.org.au> <4B7D70D0.9090003@oracle.com> <4B7D72FF.4010401@trash.net> <4B7D7617.9070600@oracle.com> <4B7D7CAA.1070605@trash.net> <4B7D7DD0.4050802@oracle.com>
In-Reply-To: <4B7D7DD0.4050802@oracle.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On 02/18/10 09:45, Patrick McHardy wrote:
>> Ah I see, we must not include nf_conntrack.h at all. Eventually
>> we need to fix this properly by making nf_conntrack.h usable
>> even with NF_CONNTRACK=n, but that's a more complicated change.
>>
>> This patch works fine for me using your config:
>>
> 
> Ack.  Thanks.
> 

Thanks, I'll send it upstream shortly.
