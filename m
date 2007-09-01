Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbXIAUkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbXIAUkX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 16:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbXIAUkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 16:40:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38528 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312AbXIAUkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 16:40:06 -0400
Message-ID: <46D9CE20.9060603@garzik.org>
Date: Sat, 01 Sep 2007 16:40:00 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Shane <shane@cm.nu>
CC: linux-kernel@vger.kernel.org
Subject: Re: intel-rng on modern hardware
References: <20070901194426.GA32713@csy.ca>
In-Reply-To: <20070901194426.GA32713@csy.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shane wrote:
> Just wondering if there is a newer version of intel-rng out
> of tree or whether modern Intel chipsets have a usable RNG. 
> I haven't been able to get intel-rng loading (no such
> device) on anything from the p965, p975 or p35 chipsets.

No modern ICH chipset has an RNG, AFAIK.

	Jeff


