Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab0BTWTZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 17:19:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:7230 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937Ab0BTWTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 17:19:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=j26uZbRLsrs7zWMzu54TDuhdStiZDVXNIl4aAJ8BActAjt4OPkcqSRsYiEoK9WLXME
         AwJrqiqkMmkNQJsuKIPEotAU+w+fy6e4BNPx5nUFsIY8GPFlPcoMnMMPOzTkiqhVh51+
         gb8i65HX7O1IU2f3bPoheFcRUiHjfjJlahN7k=
Subject: Re: [PATCH 0/14 V9] Work to enable SmartMedia/xD support in mtd
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: dedekind1@gmail.com
Cc: David Woodhouse <dwmw2@infradead.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "stanley.miao" <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1266698701.3178.0.camel@localhost.localdomain>
References: <1266443364-4538-1-git-send-email-maximlevitsky@gmail.com>
	 <1266697630.4152.0.camel@maxim-laptop>
	 <1266698701.3178.0.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Feb 2010 00:19:18 +0200
Message-ID: <1266704358.3748.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-20 at 22:45 +0200, Artem Bityutskiy wrote: 
> On Sat, 2010-02-20 at 22:27 +0200, Maxim Levitsky wrote:
> > On Wed, 2010-02-17 at 23:49 +0200, Maxim Levitsky wrote: 
> > > This is slightly updated version of my patchset.
> > > Now I can tell you for sure that hotplug works.
> > > It was used/abused for long time.
> > > I did some changes in richoh card reader driver, to work better after resume
> > > and renamed it to r852.
> > > 
> > > I kindly ask you to merge this patchset to 2.6.34.
> > > If I/users find other bugs they can be addressed by follow up patches.
> > > 
> > > Best regards,
> > > 	Maxim Levitsky
> > > 
> > > 
> > > 
> > Should I expect at least some response on that?
> > Or not?
> 
> Since you put me to CC, I answer: not from me, I have no time at all to
> look at this closely.

I know that all you are busy.
But I did put a lot of effort in this work (more that a month).

I am going to be very busy (busier that you are) very soon.
I hoped that a month is enough to review and merge my work to mtd tree.
Now all that is left in one week, so I guess all the work I did was for
nothing.

I am really frustrated.


Best regards,
Maxim Levitsky

