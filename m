Return-Path: <linux-kernel-owner+w=401wt.eu-S967587AbXEHAr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967587AbXEHAr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 20:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967547AbXEHArz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 20:47:55 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:39775 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S967496AbXEHArz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 20:47:55 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch] CFS scheduler, -v10
Date: Mon, 7 May 2007 20:47:32 -0400
Message-ID: <8E8F647D7835334B985D069AE964A4F7028FE78A@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] CFS scheduler, -v10
Thread-Index: AceQxZ3/9cfug8dBTOWpbxyebUkr8gARDxfg
References: <20070507163342.GA3502@elte.hu>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 May 2007 00:47:33.0790 (UTC) FILETIME=[77240BE0:01C7910A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] De la part de Ingo Molnar
> Envoyé : 7 mai 2007 12:34
> 
> 
> i'm pleased to announce release -v10 of the CFS scheduler patchset.
> (The main goal of CFS is to implement "desktop scheduling" 
> with as  high quality as technically possible.)
> 
> The CFS patch against v2.6.21.1 (or against v2.6.20.10) can 
> be downloaded from the usual place:
>  
>     http://people.redhat.com/mingo/cfs-scheduler/
> 
> -v10 got a bit bigger than usual. One reason for that is that 
> i couldnt resist the fine enhancements contributed by Peter 
> Williams and Mike Galbraith. Peter fixed and improved nice 
> level support and SMP load-balancing, while Mike applied his 
> "no compromises" interactivity tuning skills to CFS:
> 
>     6 files changed, 247 insertions(+), 110 deletions(-)

CFS v10 & SD 0.48 Fedora Core 6 kernels 2.6.20 build 2948 arch x86_64 & i686 are available at http://linux-dev.qc.ec.gc.ca.

> 	Ingo

- vin
