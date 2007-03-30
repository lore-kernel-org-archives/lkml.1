Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbXC3Ox3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbXC3Ox3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 10:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbXC3Ox3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 10:53:29 -0400
Received: from smtp.bulldogdsl.com ([212.158.248.8]:2713 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753234AbXC3Ox3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 10:53:29 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Bongani Hlope <bhlope@mweb.co.za>
Subject: Re: Use C++ in kernel module?
Date: Fri, 30 Mar 2007 15:53:22 +0100
User-Agent: KMail/1.9.5
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Conke Hu <conke.hu@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <5767b9100703292037n57a09807qb07c20fe589273e@mail.gmail.com> <Pine.LNX.4.61.0703300547010.31834@yvahk01.tjqt.qr> <200703300859.32305.bhlope@mweb.co.za>
In-Reply-To: <200703300859.32305.bhlope@mweb.co.za>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703301553.22751.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 March 2007 07:59, Bongani Hlope wrote:
> On Friday 30 March 2007 05:49:14 Jan Engelhardt wrote:
> > On Mar 30 2007 11:37, Conke Hu wrote:
> > > Is it possible to use C++ in linux kernel module? how?
> > > I've tested but failed, there is an unknown symbol in the .o file from
> > > c++ source code.
> >
> > You answered it yourself. Linux does not have a C++ runtime.
> > It is possible to use a very limited set of C++ features, usually not
> > worth the fight.
> >
> >
> > Jan
>
> Do the "C++ kernel modules" crowd actually know C++? If they knew how C++
> was designed, they would know that it requires some runtime support, which
> will stop them from asking this question over and over again. I'm begining
> to think that most of these questions are asked by people who think OO
> programing should used in the kernel (which is already done anyway)

Not to mention this, attached to every single LKML email:

> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

http://www.tux.org/lkml/#s15-3

"Why don't we rewrite the Linux kernel in C++?"

"Why not add a C++ interface layer to the kernel to support C++ drivers?"

"Can we make the kernel headers C++-friendly?"

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
