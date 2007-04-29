Return-Path: <linux-kernel-owner+w=401wt.eu-S1161172AbXD2VQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161172AbXD2VQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161339AbXD2VQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:16:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:64602 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161172AbXD2VQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:16:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZeIurBqEiA3WF20E4PM4PZ/P+Eax2WVPTAATum7/tXk6weKPMTmASdaegOEgfWI+fSSoZx/OtTOcXKbhCvQ0D6pGzleBTShcr8B/oRimGMX1FR4qJE3f8Gg0vu9XEAIeZJJy6AzuIBJMEDSVuKTl9Kkq0/MbDTiH5f09rehX/oM=
Message-ID: <6bffcb0e0704291416u402668ffo9bcaafb389228981@mail.gmail.com>
Date: Sun, 29 Apr 2007 23:16:51 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: Linux 2.6.21
Cc: "Diego Calleja" <diegocg@gmail.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070429211028.GT3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070428224904.GE3468@stusta.de> <p73d51n1fup.fsf@bingen.suse.de>
	 <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
	 <20070429173500.GA30248@one.firstfloor.org>
	 <alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org>
	 <20070429180909.GA30604@one.firstfloor.org>
	 <20070429214007.9ea12e96.diegocg@gmail.com>
	 <20070429201729.GQ3468@stusta.de>
	 <20070429225657.a501ab5a.diegocg@gmail.com>
	 <20070429211028.GT3468@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/04/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Sun, Apr 29, 2007 at 10:56:57PM +0200, Diego Calleja wrote:
> > El Sun, 29 Apr 2007 22:17:29 +0200, Adrian Bunk <bunk@stusta.de> escribió:
> >
> > > Bugzilla might not be perfect, but it works and it's better than doing
> > > it by hand.
> >
> > The good thing about the wiki is that it doesn't exclude bugzilla. It's
> > just a "regressions list", it doesn't intends to replace bugzilla. If a bug
> > doesn't gets fixed for a while, I don't think it's very useful to keep it
> > forever in the list like you do in the bugzilla, because I don't think
> > it's possible to fix every single bug, and it steals you time to fix bugs
> > that you are able to fix.
> >
> > It's not great but it's the best clone of you we've found 8)
>
> What exactly is the purpose of the 2.6.21 regressions list in the Wiki?

It's for -stable team.

I didn't saw any 2.6.22-stuff regression yet.

>
> cu
> Adrian

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
