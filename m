Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbXCUMcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbXCUMcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 08:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbXCUMcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 08:32:54 -0400
Received: from hu-out-0506.google.com ([72.14.214.227]:43092 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbXCUMcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 08:32:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EEwXi7nQHHLN/ViKRsT3blxsko8JlaDtadMuD12T8wTnJlI6YtP0nk3V8VeFSvaKWoQD8mZnWAXctMTlxzYoKWSOvHPtVvxdsGs7+kaPIZ8XMmydpoS/2QNx0Xh+EoOOHY4DLRD84PRWz0Xi7mWw8UbyQToxYgobRR0UnXnmm6Q=
Message-ID: <38b2ab8a0703210532p6005c720h9adfc1e0e3c4266c@mail.gmail.com>
Date: Wed, 21 Mar 2007 13:32:48 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: PCI probing failure in 2.6.21-rc3
Cc: linux-kernel@vger.kernel.org, "Greg KH" <greg@kroah.com>, bunk@stusta.de
In-Reply-To: <20070315110647.710bff5f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0703140147s24bfc656o1bbff4abc405d61d@mail.gmail.com>
	 <20070315110647.710bff5f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

[ cc'ed Adrian, since he might be interested to track this out ]

On 3/15/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> Greg, could we please either
>
> a) start doing something about these reports or
> b) publish sufficient info to permit others to do something about these
>    reports or
> c) remove the printk?
>

What am I suppose to do at this point ?

I'm sorry but I have no knowledge to sort it out by myself. Is this a
real bug or just noises that I should discard ? Should I fill a bug
report ?

Thanks
-- 
Francis
