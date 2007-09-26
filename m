Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbXIZHMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbXIZHMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 03:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbXIZHL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 03:11:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:59356 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbXIZHL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 03:11:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=guF89EgeWl4MslOxKzEjl29pX2JYC59MhM+0GL+RMUl1HGLdHKoEgEauIMxcl33jDiJLmMNJgHDq7C36rZ9vbdF2UMV9fCXUqU/kxLK9h+4Op+W7l2Rnvx4uG7X09wDTxqWONx51aCOAKrP68ovxNoNfXUSQ+6aSpT3EWCyeCqo=
Message-ID: <3f9a31f40709260011i1416d287h5d0da001dd77fbfb@mail.gmail.com>
Date: Wed, 26 Sep 2007 12:41:57 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: hufey <hufeyy@gmail.com>
Subject: Re: realtime preemption performance difference
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dmitry.adamushko@gmail.com,
       a.p.zijlstra@chello.nl, randy.dunlap@oracle.com, efault@gmx.de,
       akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com
In-Reply-To: <88dfed9d0709241427v329aeed9jfbc298666ac483c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f9a31f40709240448h4a9e8337t437328b5c675ecd5@mail.gmail.com>
	 <88dfed9d0709241427v329aeed9jfbc298666ac483c8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hello hufey,

I am not using montavista kernel, I am using standard linux kernel.

Realtime is known by worst case latencies. Ingo and team are claiming
for realtime support so their should be some samples and performance
numbers,

Can someone please share their samples and/or numbers.

Thank you,

Jaswinder Singh.

On 9/25/07, hufey <hufeyy@gmail.com> wrote:
> On 9/24/07, Jaswinder Singh <jaswinderlinux@gmail.com> wrote:
> > Hi all,
> >
> > I want to check performance difference by using realtime preemption patch :
> >
> > http://www.kernel.org/pub/linux/kernel/projects/rt/
> >
> > Please let me know from where I can download samples to test realtime
> > preemption performance difference.
> >
>
> As far as I know, some embedded linux vendors such as MontaVista
> provide kernel patch to export some interfaces to measure realtime
> performance.
>
> > Can someone please share performance numbers for your hardware:-
> >
> > 1. Interrupt latency
> > 2. Task switching time
> > 3. hard-realtime scheduling latency
> >
> > Thank you,
> >
> > Jaswinder Singh.
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
>
