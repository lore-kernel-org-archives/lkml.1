Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbZAFNqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbZAFNqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 08:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZAFNp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 08:45:58 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:56843 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751664AbZAFNp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 08:45:58 -0500
Date: Tue, 6 Jan 2009 14:45:31 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, kernel <kernel@avr32linux.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] avr32: Remove DMATEST from defconfigs
Message-ID: <20090106144531.72c181eb@hskinnemoen-d830>
In-Reply-To: <1230798141.16910.97.camel@linux-51e8.site>
References: <1230798141.16910.97.camel@linux-51e8.site>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Nizette wrote:
> In the defconfigs for ATNGW100 and ATSTK100[236] the DMA Test driver is
> compiled as a module.  This means systems built with *_defconfig +
> CONFIG_MODULES=n are unusable as the 3 dma test channels monopolise the
> CPU.
> 
> I 'spose Haavard uses this module a lot but IMO it isn't really
> something needed on all eval boards by default.
> 
> Signed-off-by: Ben Nizette <bn@niasdigital.com>
> 
> ---
> 
> Please don't hate me if this patch is munged, holiday mailer :-)

It applied just fine, thanks!

Haavard
