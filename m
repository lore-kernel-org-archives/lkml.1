Return-Path: <linux-kernel-owner+w=401wt.eu-S1761609AbXGJGiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761609AbXGJGiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 02:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbXGJGiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 02:38:03 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:59176 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbXGJGiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 02:38:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aaeY8on2CM4j1ZG1zoUV84o1neZzWo8Lu6ElZVWMp9a/PfKZc25VUnaOIBtVx7w4T5Pu383sq9veR0UWDqr3R+iUUSorY1uIXkt/gLPDK+SJ7Nm/sbo51Vw+B3FEjwf8f+OueFb5PoC5LQvkNzYZBFk+imQaRU6QFdDPQ9to0Z4=
Message-ID: <a8e1da0707092338g2c83c5es6cbe9ccba3426285@mail.gmail.com>
Date: Tue, 10 Jul 2007 06:38:00 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Documentation of kernel messages (Summary)
Cc: "Kunai, Takashi" <kunai@linux-foundation.jp>, holzheu@linux.vnet.ibm.com,
       "Rob Landley" <rob@landley.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, tim.bird@am.sony.com, gh@us.ibm.com,
       arjan@infradead.org, sam@ravnborg.org, jengelh@computergmbh.de,
       joe@perches.com, auke-jan.h.kok@intel.com, hansendc@us.ibm.com,
       davem@davemloft.net, Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
In-Reply-To: <4691C95F.7080502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1181747217.29512.9.camel@localhost.localdomain>
	 <20070613111549.db1fa4d9.akpm@linux-foundation.org>
	 <1182779321.7142.15.camel@localhost.localdomain>
	 <200706251144.48658.rob@landley.net>
	 <1182957079.6643.13.camel@localhost.localdomain>
	 <4691C480.5010600@linux-foundation.jp> <4691C95F.7080502@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On 7/9/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Kunai, Takashi wrote:
> > (1) Your kernel development proposal will be greatly supported by
> > Japanese vendor community. At the same time, it needs support from the
> > kernel communities, as well.
>
> There is a very strong reason for the kernel community to NOT support
> this: it makes it much harder to deal with bug reports.
>
> Like it or not, English is a lingua franca[1] of the technology
> industry.  When I deal with the rest of the kernel community, I use
> English, instead of my native language (Swedish).
>
> For things that are targetted toward end users, that's a different
> matter, of course, but kernel messages are inherently directed toward
> developers and technically sophisticated users.
>
I strongly agree with you.

Please keep kernel clean.
