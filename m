Return-Path: <linux-kernel-owner+w=401wt.eu-S1764538AbXESWRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764538AbXESWRY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbXESWRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:17:18 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:64196 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbXESWRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:17:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bVUt0JxpG84ExeLpSvBbtbaHJ9jvcqOfWGfuTr4O9um3NSd2BDMsLAHOYncPS4K6arPTpN7ilxpiLZeROq8bYzbNfXGUg6RvqewtT8PptRvpWt9GCVeJTsK1uu6zgUybLzjqMMN0VzYHiZx5zq5mCBa8V2FEnC+zKc1LMYQVEXA=
Message-ID: <6bffcb0e0705191517w7dc1bd08o114ae0f8a4375e37@mail.gmail.com>
Date: Sun, 20 May 2007 00:17:14 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: [2/5] 2.6.22-rc2: known regressions
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
In-Reply-To: <4376.81.207.0.53.1179612894.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F6DC9.80805@googlemail.com> <464F74C4.5070404@googlemail.com>
	 <4376.81.207.0.53.1179612894.squirrel@secure.samage.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Indan,

On 20/05/07, Indan Zupancic <indan@nul.nu> wrote:
> On Sun, May 20, 2007 00:05, Michal Piotrowski wrote:
> > Hi all,
> >
> > Here is a list of some known regressions in 2.6.22-rc2.
> >
> > Feel free to add new regressions/remove fixed etc.
> > http://kernelnewbies.org/known_regressions
>
> > Subject    : SLAB doesn't like usb_get_configuration()
> > References : http://lkml.org/lkml/2007/5/19/96
> > Submitter  : Indan Zupancic <indan@nul.nu>
> > Status     : Unknown
>
> This one is fixed: http://lkml.org/lkml/2007/5/19/171

Yes, I know ;)

Subject    : SLAB doesn't like usb_get_configuration()
References : http://lkml.org/lkml/2007/5/19/96
Submitter  : Indan Zupancic <indan@nul.nu>
Patch      : http://lkml.org/lkml/2007/5/19/171
Status     : patch available

>
> Regards,
>
> Indan
>
>
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
