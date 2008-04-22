Return-Path: <linux-kernel-owner+w=401wt.eu-S1762228AbYDVNCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762228AbYDVNCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbYDVNCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:02:31 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54427 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043AbYDVNCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:02:30 -0400
Date: Tue, 22 Apr 2008 16:01:55 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080422130155.GA16895@cs181133002.pp.htv.fi>
References: <20080419142329.GA5339@elte.hu> <200804212151.02241.vda.linux@googlemail.com> <20080422012819.GT108924158@sgi.com> <200804221448.09828.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200804221448.09828.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 02:48:09PM +0200, Denys Vlasenko wrote:
> On Tuesday 22 April 2008 03:28, David Chinner wrote:
>...
> > Patches are welcome - I'd be over the moon if any of the known 4k
> > stack advocates sent a stack reduction patch for XFS, but it seems
> > that actually trying to fix the problems is much harder than
> > resending a one line patch every few months....
> 
> Sent a few.
> I would like to ask you to ACK/NAK every individual patch
> in some reasonable period of time, say, 1-3 days. If you NAK a patch,
> please let me know what is wrong with it.
>...

I know the feeling of resending patches again and again without any 
reaction quite well, but that's not David's fault and not true for XFS 
patches, so when you try to put pressure on him you hit the wrong 
person.

> Best regards, Denys.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

