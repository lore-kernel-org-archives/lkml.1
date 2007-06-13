Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbXFMBg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbXFMBg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 21:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbXFMBgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 21:36:52 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:63462 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751389AbXFMBgv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 21:36:51 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: call for more SD versus CFS comparisons (was: Re: [ck] Mainline plans)
Date: Tue, 12 Jun 2007 21:36:18 -0400
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B01289E8@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <466DE921.9030709@debianpt.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: call for more SD versus CFS comparisons (was: Re: [ck] Mainline plans)
Thread-Index: AcesiO/OiGlZliQRQc2RTeRL2MWpLQA0RHsQ
References: <466DE921.9030709@debianpt.org>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Miguel Figueiredo" <elmig@debianpt.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       <ck@vds.kolivas.org>
Cc: "Con Kolivas" <kernel@kolivas.org>, "Ingo Molnar" <mingo@elte.hu>
X-OriginalArrivalTime: 13 Jun 2007 01:36:18.0679 (UTC) FILETIME=[3D61B070:01C7AD5B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] De la part de 
> Miguel Figueiredo
> Envoyé : 11 juin 2007 20:30
> 
> Hi all,
> 
> some results based on massing_intr.c by Satoru, can be found 
> on http://people.redhat.com/mingo/cfs-scheduler/tools/massive_intr.c
> 
> 
> I know that other people, who read lkml, also tested the same 
> way, it would be nice if they also post their data.
> 

For the pleasure of comparing CPU schedulers, both CFS v16 & full CK2 patched pre-built kernels for Fedora 7 using latest build 3194 are now available at http://linux-dev.qc.ec.gc.ca

There is also a not yet fully tuned YUM repository configuration file available at http://linux-dev.qc.ec.gc.ca/kernel/fedora/alt-sched.repo
Although I suggest you download the rpm's directly from the web page & install both manually using rpm -ivh --force

Have fun.

- vin
