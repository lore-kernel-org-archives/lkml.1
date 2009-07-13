Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZGMLOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZGMLOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 07:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbZGMLO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 07:14:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:44041 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755267AbZGMLO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 07:14:28 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18m9sE7ma8mYt4RZbaWHxE3tFSLAul9eib/Sf9uUd
	E4/b0EIjRPYhGu
Date: Mon, 13 Jul 2009 13:14:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Eirik Aanonsen <eaa@wprmedical.com>
cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>, linux-mm@kvack.org,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org
Subject: Re: SV: [BUG 2.6.30] Bad page map in process
In-Reply-To: <1DC0FF5051B91B4D88A15F21F1A27F417ABDE6@dware1013.doorway.loc>
Message-ID: <Pine.LNX.4.64.0907131312160.4212@axis700.grange>
References: <Pine.LNX.4.64.0907081250110.15633@axis700.grange><Pine.LNX.4.64.0907101900570.27223@sister.anvils><20090712095731.3090ef56@siona>
 <Pine.LNX.4.64.0907122151010.13280@axis700.grange>
 <1DC0FF5051B91B4D88A15F21F1A27F417ABDE6@dware1013.doorway.loc>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009, Eirik Aanonsen wrote:

> 
> 
> >We're currently trying to investigate and fix the hardware, will post our 
> >results.
> >
> >Thanks
> >Guennadi
> 
> ---
> 
> Are you sure this is not a compiler bug related to using version
> gcc version 4.2.2-atmel.1.0.8
> instead of using:
> gcc version 4.2.2.atmel.1.1.3

The kernel and the application are compiled with 1.1.3, the rest of the 
system should be too, not 100% sure though. I really think it is, would 
have to double check.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
