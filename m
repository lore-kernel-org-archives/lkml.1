Return-Path: <linux-kernel-owner+w=401wt.eu-S1763420AbYHDWNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763420AbYHDWNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYHDWMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:12:53 -0400
Received: from rtr.ca ([76.10.145.34]:1447 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbYHDWMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:12:53 -0400
Message-ID: <48977EE3.8050806@rtr.ca>
Date: Mon, 04 Aug 2008 18:12:51 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Robert Hancock <hancockr@shaw.ca>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata)
 and IDE
References: <fa.OGeO7gZvBG4obEzRbVltjSebgTQ@ifi.uio.no>	<fa.KtvYE2B2yrJqUleolhtMPN9ljAQ@ifi.uio.no>	<fa.AqEKTvguYFAzDFHy/We/8MpOqmo@ifi.uio.no>	<48976168.3020804@shaw.ca> <20080804205508.20a3f917@lxorguk.ukuu.org.uk>
In-Reply-To: <20080804205508.20a3f917@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> You don't. Basically it is controller dependant. Pretty much all the
> newer controllers support the 32bit PIO data cycles. Most PCI controllers
> it makes no speed difference but host bus controllers (especially
> PIIX/ICH) really benefit.
..

By "most PCI controllers", did you really mean "most add-on PCI (card) controllers"?

Nearly all onboard "PCI" controllers (integrated into the host chipset) benefit hugely,
but I suppose that is what was meant by "host bus controllers".

Cheers

