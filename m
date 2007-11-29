Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbXK2T1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbXK2T1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932583AbXK2T0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:26:55 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:42284 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932333AbXK2T0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:26:54 -0500
Date: Fri, 30 Nov 2007 01:09:20 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dhaval@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, skumar@linux.vnet.ibm.com,
       Paul Menage <menage@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: cpu accounting controller
Message-ID: <20071129193920.GI5681@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <6599ad830711122125u576e85a6w428466a0ab46dbc6@mail.gmail.com> <20071113060038.GC3359@linux.vnet.ibm.com> <6599ad830711122205g88aae4fua8dd76cf6e8ab84d@mail.gmail.com> <20071113074805.GA13499@linux.vnet.ibm.com> <6599ad830711122357i60482475o10c0e0935a9e00c0@mail.gmail.com> <20071129191737.GH5681@linux.vnet.ibm.com> <20071129192058.GC5238@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129192058.GC5238@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 08:20:58PM +0100, Ingo Molnar wrote:
> ok, this looks certainly doable for v2.6.24. I've added it to the 
> scheduler fixes queue and will let it brew there for a few days and send 
> it to Linus after that if everything goes fine - unless anyone objects. 

Thanks.

-- 
Regards,
vatsa
