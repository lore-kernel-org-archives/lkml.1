Return-Path: <linux-kernel-owner+w=401wt.eu-S1757659AbYBQKht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbYBQKht (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 05:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbYBQKhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 05:37:38 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27782 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754861AbYBQKhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 05:37:36 -0500
Message-ID: <47B80E65.7090504@panasas.com>
Date: Sun, 17 Feb 2008 12:37:25 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>, support@adaptec.com
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sergio Luis <sergio@larces.uece.br>,
       Achim Leubner <achim_leubner@adaptec.com>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.6.25-rc1-git2: GDT SCSI: change drivers/scsi/gdth.c
 into using pci_get device
References: <47B1ADCE.40202@larces.uece.br> <1202833354.3137.19.camel@localhost.localdomain> <47B1CF45.5070407@panasas.com> <47B23033.1080100@larces.uece.br> <1202861823.3137.170.camel@localhost.localdomain> <47B2B101.3090106@panasas.com> <20080216163756.GG7657@parisc-linux.org>
In-Reply-To: <20080216163756.GG7657@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Feb 2008 10:37:30.0188 (UTC) FILETIME=[18C480C0:01C87151]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16 2008 at 18:37 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, Feb 13, 2008 at 10:57:37AM +0200, Boaz Harrosh wrote:
>> I still don't have a card for testing myself. Again anyone
>> wants to send me a card. Intel people anybody home?
> 
> Apparently Intel sold this line of cards to Adaptec.  The copyright
> notice in the file backs this up:
> 
>  * Copyright (C) 1995-06 ICP vortex GmbH, Achim Leubner                 *
>  * Copyright (C) 2002-04 Intel Corporation                              *
>  * Copyright (C) 2003-06 Adaptec Inc.                                   *
>  * <achim_leubner@adaptec.com>                                          *
> 

OK I never got this guy to ping back. CCing support@adaptec.com.

Who is the right contact person, regarding the HW that is supported
by the gdth driver? Form what we see in driver commit logs (above), 
it was transfered to  Adaptec from Intel in 2003. Is that still so?

Boaz
