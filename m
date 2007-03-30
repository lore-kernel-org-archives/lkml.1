Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbXC3HKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbXC3HKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 03:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbXC3HKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 03:10:13 -0400
Received: from mail-04.jhb.wbs.co.za ([196.2.97.3]:15893 "EHLO
	mail-04.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbXC3HKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 03:10:12 -0400
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Mar 2007 03:10:11 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAIpSDEbEHh/Rh2dsb2JhbACQCQIBCA4q
From: Bongani Hlope <bhlope@mweb.co.za>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Use C++ in kernel module?
Date: Fri, 30 Mar 2007 08:59:32 +0200
User-Agent: KMail/1.9.6
Cc: Conke Hu <conke.hu@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <5767b9100703292037n57a09807qb07c20fe589273e@mail.gmail.com> <Pine.LNX.4.61.0703300547010.31834@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0703300547010.31834@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703300859.32305.bhlope@mweb.co.za>
X-Original-Subject: Re: Use C++ in kernel module?
X-Scan-Signature: db362505dd0b8a6a0465bfc0772f0abe
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 March 2007 05:49:14 Jan Engelhardt wrote:
> On Mar 30 2007 11:37, Conke Hu wrote:
> > Is it possible to use C++ in linux kernel module? how?
> > I've tested but failed, there is an unknown symbol in the .o file from
> > c++ source code.
>
> You answered it yourself. Linux does not have a C++ runtime.
> It is possible to use a very limited set of C++ features, usually not
> worth the fight.
>
>
> Jan

Do the "C++ kernel modules" crowd actually know C++? If they knew how C++ was 
designed, they would know that it requires some runtime support, which will 
stop them from asking this question over and over again. I'm begining to 
think that most of these questions are asked by people who think OO 
programing should used in the kernel (which is already done anyway)

--

A log may float in a river, but that does not make it a crocodile.
