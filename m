Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbXFOT1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbXFOT1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbXFOT0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:26:55 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:21669 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752436AbXFOT0y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:26:54 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch] CFS scheduler, -v17
Date: Fri, 15 Jun 2007 15:26:21 -0400
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0128A0A@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <20070614224908.GA9412@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] CFS scheduler, -v17
Thread-Index: Aceu1lIpu0Kwv3qBSCi2j53UbHmLEwArHE3w
References: <20070614224908.GA9412@elte.hu>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: <linux-kernel@vger.kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>
X-OriginalArrivalTime: 15 Jun 2007 19:26:22.0193 (UTC) FILETIME=[0E7BF610:01C7AF83]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] De la part de Ingo Molnar
> Envoyé : 14 juin 2007 18:49
> 
> i'm pleased to announce release -v17 of the CFS scheduler patchset.
>  
> The rolled-up CFS patch against v2.6.22-rc4, v2.6.22-rc4-mm2, 
> v2.6.21.5 or v2.6.20.13 can be downloaded from the usual place:
> 
>    http://people.redhat.com/mingo/cfs-scheduler/
>  
> -v17 includes a bigger change: the CFS-core changes in 
> preparation of the group-scheduling feature, written Srivatsa 
> Vaddagiri. Dmitry Adamushko provided cleanups and further 
> generalizations to this code and the modularization of CFS 
> has been further enhanced as a result. To users, these 
> changes are mostly invisible.
> 
> Changes since -v16:
> 
>  - lots of core updates to support group scheduling, and related 
>    cleanups. (Srivatsa Vaddagiri, Dmitry Adamushko)
> 
>  - tuned the runtime-limit up a bit, based on relentless 
> testing done by
>    Tobias Gerschner.
> 
>  - the new, precise load-calculation method for SMP balancing has been
>    further enhanced, and is now active by default. (Dmitry Adamushko)
> 
>  - fix SCHED_IDLEPRIO support (based on feedback from Thomas Sattler)
> 
>  - further updates to /proc/sched_debug and /proc/PID/sched
> 
>  - more cleanups
> 
> As usual, any sort of feedback, bugreport, fix and suggestion 
> is more than welcome!

Fedora 7 & Debian Sarge 3.1 kernels using latest CFS v17 available at http://linux-dev.qc.ec.gc.ca/
YUM users: http://linux-dev.qc.ec.gc.ca/kernel/fedora/alt-sched.repo

Thnx Ingo & cie.

> 	Ingo

- vin
