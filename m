Return-Path: <linux-kernel-owner+w=401wt.eu-S1761300AbXGKI5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761300AbXGKI5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 04:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbXGKI5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 04:57:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:60094 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734AbXGKI5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 04:57:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RVWA5qVsjxzFO4hDAEdkr5x65TFkYizRd0UStaTUIaHvdsBPIWJKQlf7Y5Zykrz87yUF+OWocD9CZvh6eq3oxIvaILFhq/JJ7EgUASqmjiGmjsRZ7CofyIJS5Znb/ixnyotE10h+r2MW05ozm1QiKcxqdwJsmVLxDbThTbbo9Jw=
Message-ID: <8d6898730707110157g7ddd7a27of0e0a02fe1afbdc4@mail.gmail.com>
Date: Wed, 11 Jul 2007 14:27:05 +0530
From: "Nobin Mathew" <nobin.mathew@gmail.com>
To: "Manu Abraham" <abraham.manu@gmail.com>
Subject: Re: Reading a physical memory location
Cc: "vraghavan3@mail.gatech.edu" <vraghavan3@mail.gatech.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1a297b360707110150x56e8ad6cu64ab768e7d3ce6ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184010444.469290cce48df@webmail.mail.gatech.edu>
	 <8d6898730707091539y14cf5afbsed7ed769526da0a1@mail.gmail.com>
	 <1184091142.4693cc06850f7@webmail.mail.gatech.edu>
	 <1a297b360707101502t2670f0d7g5197b9c32ecb967c@mail.gmail.com>
	 <8d6898730707102243t60861fdar147f052501c31958@mail.gmail.com>
	 <1a297b360707110111u25a786c5m4857673e3e1b90a1@mail.gmail.com>
	 <8d6898730707110114p3c02e24as8ca8359731fdc320@mail.gmail.com>
	 <1a297b360707110150x56e8ad6cu64ab768e7d3ce6ed@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks

On 7/11/07, Manu Abraham <abraham.manu@gmail.com> wrote:
> On 7/11/07, Nobin Mathew <nobin.mathew@gmail.com> wrote:
> > See this in the documentation
> >
> > The returned virtual address is a current CPU mapping for the memory
> > address given. It is only valid to use this function on addresses that
> > have a kernel mapping
> >
> > This function does not handle bus mappings for DMA transfers. In
> > almost all conceivable cases a device driver should not be using this
> > function
> >
>
> To get a better idea, look here
> http://tldp.org/LDP/khg/HyperNews/get/devices/addrxlate.html
>
