Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab0BRX3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 18:29:36 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55224 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752040Ab0BRX3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 18:29:35 -0500
Date: Thu, 18 Feb 2010 23:33:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] libata: pass host flags into
 __ata_pci_sff_init_one() helper
Message-ID: <20100218233312.2f9a47c3@lxorguk.ukuu.org.uk>
In-Reply-To: <201002182341.02203.bzolnier@gmail.com>
References: <20100218185914.16594.61415.sendpatchset@localhost>
	<20100218185922.16594.98925.sendpatchset@localhost>
	<20100218214448.692552fd@lxorguk.ukuu.org.uk>
	<201002182341.02203.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - __ has been also used for exactly such purpose in the kernel, i.e.:

As helpers for inlines and like the yes... 

Matter of style anyway.
