Return-Path: <linux-kernel-owner+w=401wt.eu-S1751642AbXDUX7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbXDUX7k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 19:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbXDUX7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 19:59:40 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:5661 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751642AbXDUX7j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 19:59:39 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [ck] [ANNOUNCE] Staircase Deadline cpu scheduler version 0.44
Date: Sat, 21 Apr 2007 19:59:07 -0400
Message-ID: <8E8F647D7835334B985D069AE964A4F7033AB5DB@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [ck] [ANNOUNCE] Staircase Deadline cpu scheduler version 0.44
Thread-Index: AceD6rY8jpwi6MqiRX2DJk4ajy/zDwAg07Ug
References: <200704211757.12277.kernel@kolivas.org>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Con Kolivas" <kernel@kolivas.org>, "ck list" <ck@vds.kolivas.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 21 Apr 2007 23:59:08.0593 (UTC) FILETIME=[0CE62A10:01C78471]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : ck-bounces@vds.kolivas.org 
> [mailto:ck-bounces@vds.kolivas.org] De la part de Con Kolivas
> Envoyé : 21 avril 2007 03:57
> 
> A significant bugfix for forking tasks was just posted, so 
> here is an updated version of the staircase deadline cpu 
> scheduler. This may cause noticeable behavioural improvements 
> under certain workloads (such as compiling software with make).
> 
> Thanks to Al Boldi for making me check the fork code!
> 
> http://ck.kolivas.org/patches/staircase-deadline/2.6.20.7-sd-0.44.patch
> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc7-sd-0.44.patch
> 
> Incrementals in
> http://ck.kolivas.org/patches/staircase-deadline/2.6.20.7/
> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc7/
> 
> Renicing X to -10, while not essential, is preferable.
> 
> See the patch just posted called 'sched: implement staircase 
> scheduler yaf fix' for full changelog.

Kernels for FC6 x86_64 & i686 using SD 0.44 and latest source (2944) now available at http://linux-dev.qc.ec.gc.ca

Note that backport patches for 2.6.18 & 2.6.19 kernels are also available.

> 
> --
> -ck
> 

Again, nice work CK!

-vin
