Return-Path: <linux-kernel-owner+w=401wt.eu-S1031293AbXECMlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031293AbXECMlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031299AbXECMlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:41:37 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:41053 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1031293AbXECMlg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:41:36 -0400
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
Subject: RE: [ck] Staircase Deadline cpu scheduler version 0.48 - 2.6.18 to 2.6.20 backports patches
Date: Thu, 3 May 2007 08:41:12 -0400
Message-ID: <8E8F647D7835334B985D069AE964A4F7033AB5F1@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [ck] Staircase Deadline cpu scheduler version 0.48 - 2.6.18 to 2.6.20 backports patches
Thread-Index: AceNTPWCmAOEUT0+TV63jzUoZyL/pAAK2yPw
References: <200705031630.24913.kernel@kolivas.org>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Con Kolivas" <kernel@kolivas.org>, <linux-kernel@vger.kernel.org>,
       <ck@vds.kolivas.org>
X-OriginalArrivalTime: 03 May 2007 12:41:12.0562 (UTC) FILETIME=[550D6520:01C78D80]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : ck-bounces@vds.kolivas.org 
> [mailto:ck-bounces@vds.kolivas.org] De la part de Con Kolivas
> Envoyé : 3 mai 2007 02:30
> 
> I've done some minor cleanups and microoptimisations to the 
> code since version
> 0.46 in preparation for releasing -ck with SD as its base.
> 
> http://www.kernel.org/pub/linux/kernel/people/ck/patches/stair
> case-deadline/2.6.21/2.6.21-sd-0.48.patch

Hi all,

I made backport patches of SD 0.48 for 2.6.18.8, 2.6.19.7 & 2.6.20.11 kernels and also diff patches 0.46 -> 0.47 -> 0.48.

All info & download available at http://linux-dev.qc.ec.gc.ca

There are also various versions of SD & CFS kernels for FC6 & Debian Sarge/Etch

> --
> -ck

- vin
