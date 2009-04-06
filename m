Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbZDFJKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbZDFJKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbZDFJJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:09:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51721 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754696AbZDFJJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:09:57 -0400
Date: Mon, 6 Apr 2009 10:10:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mithlesh Thukral <mithlesh@linsyssoft.com>,
       Christopher Harrer <charrer@alacritech.com>
Subject: Re: Staging: sxg: Add support to download the firmware using
 request_firmware()
Message-ID: <20090406101026.04040c13@lxorguk.ukuu.org.uk>
In-Reply-To: <20090406023349.GA1314@suse.de>
References: <200904051919.n35JJUUq031448@hera.kernel.org>
	<1238978493.11870.2.camel@macbook.infradead.org>
	<20090406010754.GA32630@suse.de>
	<1238980795.11870.12.camel@macbook.infradead.org>
	<20090406023349.GA1314@suse.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Firmware isn't "crap", it's needed by devices, and I don't see the
> problem of distributing it within the kernel tree, especially when the
> license of the firmware is just fine, like these files are.

For one firmware doesn't tie to the kernel release cycle so any
serious distribution has to split the two packages apart even if the
kernel community didn't.

For a second it keeps a lot of irrelevant, unreviewable enormous hex file
changesets *off* the kernel lists and out of the git tree tracking.


Alan
