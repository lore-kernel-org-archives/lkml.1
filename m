Return-Path: <linux-kernel-owner+w=401wt.eu-S1751288AbXDILcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbXDILcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 07:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbXDILcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 07:32:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53624 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbXDILcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 07:32:41 -0400
Message-ID: <461A2457.1080801@garzik.org>
Date: Mon, 09 Apr 2007 07:32:39 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] pata_platform for ARM RiscPC
References: <20070330110022.GA21653@flint.arm.linux.org.uk> <20070330110800.GB21653@flint.arm.linux.org.uk>
In-Reply-To: <20070330110800.GB21653@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> Add pata_platform device for RiscPC, thereby converting the primary
> IDE channel on the machine to PATA.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

ACK

BTW, please CC linux-ide on anything related to old-IDE or libata.  Thanks.


> Since this is dependent on the previous patch (to avoid build errors)
> this needs to wait until the devm_ioport patch is merged.  I'll
> therefore push this through the ARM tree at the appropriate time.

Sounds good.

	Jeff


