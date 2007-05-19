Return-Path: <linux-kernel-owner+w=401wt.eu-S1764483AbXESUu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764483AbXESUu1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 16:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760206AbXESUuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 16:50:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:35667 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860AbXESUuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 16:50:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=exXmPiitVwWITGxN8VIg7kG6nrpoSYNr4Uqn232JSaGaiNHRInpH1CVa7UxqOapSPMqFCoChnKt3yQVvdxGk5JdD8gebtTBvjzwIRAqLEjFWYLb6/bp/6QsoX1KwMxQmMRQSjStEe/IThGbRgBjNUxLPuRhz988MDaswJaxkEa4=
Message-ID: <6bffcb0e0705191350l71d9ebeeo7e0f90582355af5f@mail.gmail.com>
Date: Sat, 19 May 2007 22:50:14 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.22-rc1 regression: tifm prevents suspending [was: Re: [2.6.22-rc1-mm1] vaio laptop (SZ72B) immediately resumes after STR]
Cc: "Mattia Dongili" <malattia@linux.it>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Alex Dubov" <oakad@yahoo.com>,
       "Pierre Ossman" <drzeus@drzeus.cx>
In-Reply-To: <200705192029.37436.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070518071523.GA3195@inferi.kami.home>
	 <20070519151110.GA3393@inferi.kami.home>
	 <6bffcb0e0705191017n1d1e6eb7k1370d5ce5cf17fb9@mail.gmail.com>
	 <200705192029.37436.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/05/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, 19 May 2007 19:17, Michal Piotrowski wrote:
[..]
> > Subject    : Broken suspend on SMP with tifm
> > References : http://lkml.org/lkml/2007/5/13/161
> > Submitter  : Rafael J. Wysocki <rjw@sisk.pl>
> > Status     : patch was suggested
> >
> > Actually should be "a few patches was suggested"
> >
> > Rafael, please point me the right patch.
>
> Fixed in the mainline, by
>
> commit e3dfd2964ea86ae65f511b10d62ea54d46db3708
> make freezeable workqueues singlethread

Thanks for the information.

>
> Greetings,
> Rafael
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
