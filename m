Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab0CIUEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 15:04:15 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39184 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab0CIUEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:04:11 -0500
Message-ID: <4B96A9B2.8070806@cs.helsinki.fi>
Date: Tue, 09 Mar 2010 22:04:02 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: mm: Do not iterate over NR_CPUS in __zone_pcp_update()
References: <alpine.LFD.2.00.1003081018070.22855@localhost.localdomain> <84144f021003080529w1b20c08dmf6871bd46381bc71@mail.gmail.com> <4B95AD17.2030106@kernel.org> <alpine.DEB.2.00.1003090910200.28897@router.home>
In-Reply-To: <alpine.DEB.2.00.1003090910200.28897@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 9 Mar 2010, Tejun Heo wrote:
> 
>> Yeap, that's buggy.
>>
>> Acked-by: Tejun Heo <tj@kernel.org>
>>
>> I suppose this would go through the mm tree?
> 
> As you said: Its a bug so it needs to be applied to upstream.

Sure but someone needs to pick up the patch and send it to Linus. Andrew?

			Pekka
