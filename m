Return-Path: <linux-kernel-owner+w=401wt.eu-S1757774AbZKSXgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbZKSXgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 18:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbZKSXgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 18:36:18 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60291 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755527AbZKSXgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 18:36:17 -0500
Date: Thu, 19 Nov 2009 23:38:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Message-ID: <20091119233802.65cdb4f8@lxorguk.ukuu.org.uk>
In-Reply-To: <4B05BF3F.3040407@garzik.org>
References: <20091117144450.15430.83450.stgit@localhost.localdomain>
	<200911181919.19127.bzolnier@gmail.com>
	<4B05BA72.2030406@garzik.org>
	<200911192242.59476.bzolnier@gmail.com>
	<4B05BF3F.3040407@garzik.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh, I'm happy to wait until one of two scenarios occurs:
> 
> 1) Bart annoys Alan sufficiently to motivate Alan to add feature X

I'm rather hard to annoy but I'm happy Bart is going over the drivers.
Whatever his motivation I am very sure he'll find more bugs in the
process. He'll even be able to correct blame me for a few I am sure.

> 2) Alan annoys Bart sufficiently to motivate Bart to add feature X

Well latest score is Bart fixes libata bug, Alan fixes the IDE tree
version. Not quite the expected outcome but who cares ;)

Alan
