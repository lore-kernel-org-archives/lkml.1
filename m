Return-Path: <linux-kernel-owner+w=401wt.eu-S1161696AbXEAKX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161696AbXEAKX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161691AbXEAKX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:23:58 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37277 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161686AbXEAKX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:23:57 -0400
Date: Tue, 1 May 2007 11:27:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 2/4] SoC base drivers: ASIC3 SoC hardware
 definitions
Message-ID: <20070501112751.6b1d9452@the-village.bc.nu>
In-Reply-To: <20070430235642.e576e917.akpm@linux-foundation.org>
References: <516386418.20070501080839@gmail.com>
	<20070430235642.e576e917.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > + * Copyright 2001 Compaq Computer Corporation.
> > + *
> > + * Use consistent with the GNU GPL is permitted,
> > + * provided that this copyright notice is
> > + * preserved in its entirety in all copies and derived works.
> > + *
> > + * COMPAQ COMPUTER CORPORATION MAKES NO WARRANTIES, EXPRESSED OR IMPLIED,
> > + * AS TO THE USEFULNESS OR CORRECTNESS OF THIS CODE OR ITS
> > + * FITNESS FOR ANY PARTICULAR PURPOSE.

This doesn't appear to be self consistent or GPL compatible. Any binary
will be a derivative work and will not contain the copyright notice. 

Alan
