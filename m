Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbZKTTVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbZKTTVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 14:21:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447AbZKTTVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 14:21:05 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36817 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755264AbZKTTVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:21:04 -0500
Date: Fri, 20 Nov 2009 19:23:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] sdio_uart: Switch to the open/close helpers
Message-ID: <20091120192300.0751534f@lxorguk.ukuu.org.uk>
In-Reply-To: <20091120173517.GA14888@kroah.com>
References: <20091118141802.3582.47363.stgit@localhost.localdomain>
	<20091118141952.3582.66265.stgit@localhost.localdomain>
	<20091120173517.GA14888@kroah.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Something is wierd here, this patch doesn't apply.  And if I do it by
> hand and fix up the errors, then patch 7 doesn't apply.
> 
> Wierd.

wEIrd (sorry pet hate)

> How about I take the first 5 and then you resync and send me the next 6?

Works for me.
