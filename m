Return-Path: <linux-kernel-owner+w=401wt.eu-S1762041AbXE2RHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762041AbXE2RHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXE2RHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:07:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:59550 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbXE2RHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:07:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DV0gA0iLoZCicwlaf/9zwz21+pCVJDHbvvaKjGWsDKeYEezhgzWaCh4vorfT9/LrxjZRauxCKhWK3mv/aE8zJipxt+IEbDAO1ZxeNN++y/U2sXtyVhHModkcAH7beOJBTwPh4r1CtrkVEQp8p/SFBG5sNoPDxrAa171cuDp5usk=
Message-ID: <29495f1d0705291007p2448ea9dl51fa597c59a2d16f@mail.gmail.com>
Date: Tue, 29 May 2007 10:07:40 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: Regression: USB is nfg after suspend/resume(RAM) cycle on Intel chipset
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Greg KH" <gregkh@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <465C5D25.2050303@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <465C566E.4030009@rtr.ca>
	 <alpine.LFD.0.98.0705290945520.26602@woody.linux-foundation.org>
	 <465C5C16.7020001@rtr.ca> <465C5D25.2050303@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/07, Mark Lord <lkml@rtr.ca> wrote:
> Mmmm.. is there a way to get the raw patches out of the http://git.kernel.org/
> browser windows ?
>
> Clicking on "diff" gives me a fancy HTML coloured diff,
> whereas I need just the raw patch so I can revert it.

Click on "raw"? e.g.:

summary | shortlog | log | commit | commitdiff | tree
raw (parent: 1ea0975)

Neare the top.

Thanks,
Nish
