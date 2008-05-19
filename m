Return-Path: <linux-kernel-owner+w=401wt.eu-S1764869AbYESXG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764869AbYESXG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763962AbYESXGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:06:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:59745 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763903AbYESXGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:06:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BFfSL/tT88qjjaHgD32JQeaeaTgugsjAyHJd8oV5M96Ov42NstOV9LtFVQ3/XUEgEsT9+qJI/Il0u5M6E8KsNvD1LrsC0iBDCVU27UMFCszH8FhFib+EbLtzi0VZDLJN/ugdt1rwcaNFCH7Y048z1WJ0JkeWX/fSLH2H8lw2h18=
Message-ID: <9e4733910805191606y7aa3287le2b461032ad9c97a@mail.gmail.com>
Date: Mon, 19 May 2008 19:06:22 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] cpufreq: remove CVS keywords
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080519225807.GE17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080519220315.GG17716@cs181133002.pp.htv.fi>
	 <9e4733910805191542m671a2200je2d9251721cbdf90@mail.gmail.com>
	 <20080519225807.GE17716@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/19/08, Adrian Bunk <bunk@kernel.org> wrote:
> On Mon, May 19, 2008 at 06:42:21PM -0400, Jon Smirl wrote:
>  > On 5/19/08, Adrian Bunk <bunk@kernel.org> wrote:
>  > > This patch removes CVS keywords that weren't updated for a long time
>  > >  from comments.
>  > >
>  > >  Signed-off-by: Adrian Bunk <bunk@kernel.org>
>  >
>  > Thanks for doing this. I'd love to see all CVS keywords removed from
>  > the kernel source.
>
>
> I did only the clear-cut cases in this batch (we even have several
>  keywords containing 2007 dates, and if someone actually maintains his
>  code in CVS that's legitimate usage), but I'll reduce them further in
>  the future.
>
>
>  > I've spent countless hour cleaning up kernel
>  > patches after various embedded vendors checked their kernel source
>  > into CVS and then generated patch sets containing their changes plus
>  > all of the expanded keywords.
>
>
> Guess what experience motivated me to do these patches...

The $log ones are the most evil. It is hard to automatically remove
the changes from the diffs.

>
>  > Jon Smirl
>
>  cu
>  Adrian
>
>
>  --
>
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
>
>


-- 
Jon Smirl
jonsmirl@gmail.com
