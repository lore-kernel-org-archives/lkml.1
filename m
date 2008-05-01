Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbYEAKGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbYEAKGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 06:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbYEAKGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 06:06:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37599 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbYEAKGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 06:06:03 -0400
Subject: Re: [PATCH 1/1] Embedded Maintainer(s), linux-embedded@vger list
From: David Woodhouse <dwmw2@infradead.org>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <e2e108260805010255v6b728998i7d4952cc8fec28cb@mail.gmail.com>
References: <1209577322.25560.402.camel@pmac.infradead.org>
	 <1209577483.25560.405.camel@pmac.infradead.org>
	 <e2e108260805010255v6b728998i7d4952cc8fec28cb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 01 May 2008 11:05:59 +0100
Message-Id: <1209636359.25560.512.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 11:55 +0200, Bart Van Assche wrote:
> It's great that more attention is being paid to the use of Linux in
> embedded systems. And the MAINTAINERS file is probably the right file
> to add the above information. But I'm afraid that the way the above
> information is formatted will cause confusion. As an example, recently
> there was a driver added to the Linux kernel for the PCF8575 chip.
> This is an I2C chip that is only used in embedded systems. Regarding
> driver review, should any such drivers be sent to the I2C mailing
> list, the embedded mailing list or both ? The MAINTAINERS file should
> be clear on this.

The I²C list would be the best place to send such a patch. You could
also copy it to the linux-embedded list if it's likely to be of interest
to a reasonable proportion of "embedded" developers, but that wouldn't
be the primary route into Linus' tree for most things.

I can't really see any way to make that clear in the MAINTAINERS file
that wouldn't be clumsy and just as confusing -- I think it'll work out
just fine by itself. Do you have a concrete proposal?

-- 
dwmw2

