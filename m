Return-Path: <linux-kernel-owner+w=401wt.eu-S965869AbXCLNzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965869AbXCLNzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965871AbXCLNzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:55:14 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:55864 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965869AbXCLNzN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:55:13 -0400
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
Subject: RE: [ck] Re: RSDL v0.30 cpu scheduler for ... 2.6.18.8 kernel
Date: Mon, 12 Mar 2007 09:54:46 -0400
Message-ID: <8E8F647D7835334B985D069AE964A4F7028FE62F@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [ck] Re: RSDL v0.30 cpu scheduler for ... 2.6.18.8 kernel
Thread-Index: AcdkmjtTTmv+FUU3T7a1BbLDwfbRtAAENPCw
References: <8E8F647D7835334B985D069AE964A4F7028FE62A@ECQCMTLMAIL1.quebec.int.ec.gc.ca> <200703121545.06379.kernel@kolivas.org> <200703121221.28912.mgd@technosis.de> <200703122232.54919.kernel@kolivas.org>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Con Kolivas" <kernel@kolivas.org>, <ck@vds.kolivas.org>,
       <mgd@technosis.de>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Mar 2007 13:54:46.0825 (UTC) FILETIME=[FEAD7990:01C764AD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Monday 12 March 2007 22:21, Michael Gerdau wrote:
> > > > And here are the backported RSDL 0.30 patches in case any of you

> > > > would still be running an older 2.6.18.8 kernel ...
> >
> > The original mail doesn't seem to have made it to the ck-list.
> >
> > Where would I find the backported RSDL 0.30 patches for 2.6.18.8 ?
> 
> It might have been filtered due to containing attachments, or 
> because the author wasn't a member of the mailing list, sorry.
> 

I've found a place to put theses patches to:
http://linux-dev.qc.ec.gc.ca/kernel/rsdl/2.6.18.8-rsdl-0.30.patch
http://linux-dev.qc.ec.gc.ca/kernel/rsdl/2.6.18.8-rsdl-0.29-0.30.patch


There is also a Debian Etch x86_64 2.6.18-rsdl-0.30 kernel available at:
http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/linux-headers-2.6
.18.8-rsdl-0.30-amd64-envcan_2.6.18.8-rsdl-0.30-003_amd64.deb
http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/linux-image-2.6.1
8.8-rsdl-0.30-amd64-envcan_2.6.18.8-rsdl-0.30-003_amd64.deb


Hope this helps!

-vin
