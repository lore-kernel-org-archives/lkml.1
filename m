Return-Path: <linux-kernel-owner+w=401wt.eu-S1761537AbXIVGsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761537AbXIVGsW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 02:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbXIVGsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 02:48:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56921 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176AbXIVGsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 02:48:14 -0400
Date: Sat, 22 Sep 2007 12:20:59 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Mel Gorman <mel@skynet.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, jeff@garzik.org
Subject: Re: 2.6.23-rc6-mm1: Build failures on ppc64_defconfig
In-Reply-To: <alpine.LFD.0.999.0709201903180.17093@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0709221218250.22517@enigma.security.iitk.ac.in>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
 <20070920132512.GF24105@skynet.ie>
 <alpine.LFD.0.999.0709201903180.17093@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 Sep 2007, Satyam Sharma wrote:
> 
> BTW ppc64_defconfig didn't quite like 2.6.23-rc6-mm1 either ...
> IIRC I got build failures in:

> drivers/ata/pata_scc.c

http://lkml.org/lkml/2007/9/21/557
