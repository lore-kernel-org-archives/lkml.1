Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab0BKOto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 09:49:44 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:60250 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab0BKOtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:49:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Fmjuzr9LasG7WulU9RFDiRZD7lzGyqQ7LnwS9Be9owbzVqq/qwvM9Bqu5e3b25qSs2
         ngmLqtz17AbGNc3UL9Sxd8FNOZVq8MBB0X/UebwVyO8PSuJbXflsLsO+n4ibQYnEpG5o
         kOo/9POqQpN64fc/c8yiBwJWdGgSziHG9Ikf0=
Date: Thu, 11 Feb 2010 15:49:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Maneesh Soni <maneesh@in.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin <schwidefsky@de.ibm.com>
Subject: Re: [GIT PULL] hw-breakpoint fix
Message-ID: <20100211144924.GA4915@nowhere>
References: <1265248014-7338-1-git-send-regression-fweisbec@gmail.com> <4B73E60B.1000104@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B73E60B.1000104@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 04:42:11PM +0530, Mahesh Jagannath Salgaonkar wrote:
> Hi Ingo,
>
> Will this patch be pushed in to Linux tree? This patch contains ABI  
> chnage w.r.t hardware breakpoint info layout and needs to go in .33
>
> Thanks,
> -Mahesh.


It is in the tip:perf/urgent branch, which means Ingo will likely send
a pull request soon with this patch inside.

Thanks.

