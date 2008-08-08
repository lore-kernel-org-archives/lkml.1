Return-Path: <linux-kernel-owner+w=401wt.eu-S1759816AbYHHU0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816AbYHHU0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYHHUZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:25:50 -0400
Received: from bizon.gios.gov.pl ([212.244.124.8]:58108 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbYHHUZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:25:49 -0400
Date: Fri, 8 Aug 2008 22:24:08 +0200 (CEST)
From: Krzysztof Oledzki <ole@ans.pl>
X-X-Sender: ole@bizon.gios.gov.pl
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, NetDev <netdev@vger.kernel.org>
Subject: Re: Warning/Oops report of the week of August 7th, 2008
In-Reply-To: <489B179F.1080704@linux.intel.com>
Message-ID: <alpine.LNX.1.10.0808082222570.18680@bizon.gios.gov.pl>
References: <489B179F.1080704@linux.intel.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Aug 2008, Arjan van de Ven wrote:
<CUT>

> Rank 7: nf_conntrack_acct_fini (warning)
> 	Reported 67 times
> 	Bug in the netfilter procfs code exposed by Al's recent cleanups
> 	This warning was last seen in version 2.6.27-rc2, and first seen in 
> 2.6.27-rc1.
> 	More info: 
> http://www.kerneloops.org/searchweek.php?search=nf_conntrack_acct_fini

Should be fixed by:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=9714be7da8b32f36d2468fe08ff603b6402df8cf

Best regards,

 				Krzysztof Oledzki
