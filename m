Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbXFAWza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbXFAWza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXFAWzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:55:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:42176 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbXFAWzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=csLoTqeKmkV9i4LUJCkg421KW5Eft/uPdTQ4JD7Z+HqFc9U4YkvJqFUHOlIJCAKUqXSSmBMAeV+AbMQ09F1GOM02EoQQQnAoYsp3SPbToOMXRvPhU9a/WMi4xRgbjD5gfJPSLb72SJgoe4HffL/aCAR+g1AShyvjd2h8jPTkCYY=
Message-ID: <b00ca3bd0706011555p1b1377b4p907947c9d94ee625@mail.gmail.com>
Date: Sat, 2 Jun 2007 06:55:21 +0800
From: "Antonino Daplas" <adaplas@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [3/3] 2.6.22-rc3: known regressions with patches v2
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Tero Roponen" <teanropo@jyu.fi>,
       "Satoru Takeuchi" <takeuchi_satoru@jp.fujitsu.com>,
       "Oleg Nesterov" <oleg@tv-sign.ru>, zach@vmware.com,
       "=?ISO-8859-1?Q?Toralf_F=F6rster?=" <toralf.foerster@gmx.de>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, "Andi Kleen" <ak@suse.de>,
       discuss@x86-64.org, "Jeff Garzik" <jeff@garzik.org>,
       "Ben Collins" <ben.collins@ubuntu.com>
In-Reply-To: <46600F6B.3060601@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46600D36.7060405@googlemail.com> <46600F6B.3060601@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/1/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> Hi all,
>
> Subject    : tty-related oops in latest kernel(s)
> References : http://lkml.org/lkml/2007/5/27/104
> Submitter  : Tero Roponen <teanropo@jyu.fi>
> Handled-By : Antonino A. Daplas <adaplas@gmail.com>
> Patch      : http://lkml.org/lkml/2007/5/31/35
> Status     : patch available
>
It's not actually a regression, but a long-standing, undetected bug
exposed by slub.

Anyway, the patch is already in Linus' tree.  You can remove this from
your list.

Tony
