Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbZDMI1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbZDMI1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 04:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZDMI13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 04:27:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51180 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbZDMI12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 04:27:28 -0400
Message-ID: <49E2F76B.9080706@garzik.org>
Date: Mon, 13 Apr 2009 04:27:23 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Arjan van de Ven <arjan@linux.intel.com>, Jeff Garzik <jgarzik@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: fix obviously wrong comment
References: <20090408162452.GA10440@damson.cased.tu-darmstadt.de>
In-Reply-To: <20090408162452.GA10440@damson.cased.tu-darmstadt.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
>>From 776d93d1e11ff79ed2693541b0663dbb2ffa3aee Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Wed, 8 Apr 2009 18:19:39 +0200
> Subject: [PATCH] ata: fix obviously wrong comment
> 
> Also remove the now-useless debug printouts which are supposed to
> tell us when the scan starts and ends.
> 
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  drivers/ata/libata-core.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)

applied

