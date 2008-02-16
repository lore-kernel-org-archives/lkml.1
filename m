Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbYBPQiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbYBPQiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 11:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbYBPQh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 11:37:59 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:46760 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbYBPQh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 11:37:58 -0500
Date: Sat, 16 Feb 2008 09:37:57 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sergio Luis <sergio@larces.uece.br>,
       Achim Leubner <achim_leubner@adaptec.com>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.6.25-rc1-git2: GDT SCSI: change drivers/scsi/gdth.c into using pci_get device
Message-ID: <20080216163756.GG7657@parisc-linux.org>
References: <47B1ADCE.40202@larces.uece.br> <1202833354.3137.19.camel@localhost.localdomain> <47B1CF45.5070407@panasas.com> <47B23033.1080100@larces.uece.br> <1202861823.3137.170.camel@localhost.localdomain> <47B2B101.3090106@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B2B101.3090106@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 10:57:37AM +0200, Boaz Harrosh wrote:
> I still don't have a card for testing myself. Again anyone
> wants to send me a card. Intel people anybody home?

Apparently Intel sold this line of cards to Adaptec.  The copyright
notice in the file backs this up:

 * Copyright (C) 1995-06 ICP vortex GmbH, Achim Leubner                 *
 * Copyright (C) 2002-04 Intel Corporation                              *
 * Copyright (C) 2003-06 Adaptec Inc.                                   *
 * <achim_leubner@adaptec.com>                                          *

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
