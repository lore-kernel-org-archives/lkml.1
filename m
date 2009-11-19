Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbZKSPWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbZKSPWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 10:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZKSPWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 10:22:45 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44205 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755723AbZKSPWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 10:22:44 -0500
Date: Thu, 19 Nov 2009 15:24:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Message-ID: <20091119152443.5ff3c949@lxorguk.ukuu.org.uk>
In-Reply-To: <200911191616.35033.bzolnier@gmail.com>
References: <20091117144450.15430.83450.stgit@localhost.localdomain>
	<20091119143351.1d0e2c59@lxorguk.ukuu.org.uk>
	<200911191550.25476.bzolnier@gmail.com>
	<200911191616.35033.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If you know about other drivers still using ->pre_reset for cable detection
> > please let us know because they need fixing ASAP.
> 
> No need for it any longer.  I'll send patches later.

Works for me - not a bug fix as you make out but it's a clean up that is
worth doing.
 
Alan
