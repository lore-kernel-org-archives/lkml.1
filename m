Return-Path: <linux-kernel-owner+w=401wt.eu-S1762465AbXGRWc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762465AbXGRWc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbXGRWcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:32:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:53946 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbXGRWcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:32:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=id2inxWNgnYwlk68nNRVMggdh9MX3KdvZ1ujnahnwk+zzEUvq6bolEv+nwQouwo87nQJRAhS08u9bYEcBqdzfYu1vru25j8D7G+BCpRLR4fHThps4lXrb8RxCdhgdiO4gmyip/uX8V2jG2RI8TRvpvr2pMYv4UySTabuggTNJgE=
Message-ID: <86802c440707181532r6b8b0820ob1fc773f4fdbdbba@mail.gmail.com>
Date: Wed, 18 Jul 2007 15:32:15 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 3/3]x86_64: early_printk for early debug port support
Cc: "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, "Greg KH" <gregkh@suse.de>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200707190010.53702.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440705202219k5aa758ffk217626424e613ec7@mail.gmail.com>
	 <200707190010.53702.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/07, Andi Kleen <ak@suse.de> wrote:
> On Monday 21 May 2007 07:19:18 Yinghai Lu wrote:
> > add early dbgp to early_printk.
> >
> > kernel command line:
> > earlyprintk=dbgp
> > or
> > earlyprintk=dbgp1
>
> Just checking some old patches. Was there ever an update for this one?
> What were the testing results?

not yet.

will create one from my local tree tonight.

YH
