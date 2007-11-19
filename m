Return-Path: <linux-kernel-owner+w=401wt.eu-S1751322AbXKSTqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbXKSTqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 14:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbXKSTql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:46:41 -0500
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:57838 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750973AbXKSTqk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:46:40 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3,v2.6.23.8, v2.6.22.13, v2.6.21.7
Date: Mon, 19 Nov 2007 14:46:12 -0500
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0B897C3@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <20071119185237.GA10965@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3,v2.6.23.8, v2.6.22.13, v2.6.21.7
Thread-Index: Acgq3WYxPIbb8QVnQQa5rmmEc1yxyAAB1IEA
References: <20071119151756.GA25446@elte.hu> <20071119181207.GA11900@codepoet.org> <20071119185237.GA10965@elte.hu>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Ingo Molnar" <mingo@elte.hu>, <andersen@codepoet.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Nov 2007 19:46:13.0611 (UTC) FILETIME=[D77AABB0:01C82AE4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] De la part de Ingo Molnar
> 
> 
> * Erik Andersen <andersen@codepoet.org> wrote:
> 
> > On Mon Nov 19, 2007 at 04:17:56PM +0100, Ingo Molnar wrote:
> > > 
> > > By popular demand, here is release -v24 of the CFS 
> scheduler patch.
> > > 
> > > It is a full backport of the latest & greatest scheduler code to 
> > > v2.6.24-rc3, v2.6.23.8, v2.6.22.13, v2.6.21.7. The patches can be 
> > > downloaded from the usual place:
> > > 
> > >     http://people.redhat.com/mingo/cfs-scheduler/
> > 
> > Doesn't compile with 2.6.21.7:
> 
> does the patch below help?
> 

Looks good.  Compiling.

- vin
