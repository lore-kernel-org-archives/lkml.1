Return-Path: <linux-kernel-owner+w=401wt.eu-S1763166AbXJRAWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763166AbXJRAWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762611AbXJRAVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:21:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49943 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761813AbXJRAVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:21:49 -0400
Message-ID: <4716A70C.6090307@garzik.org>
Date: Wed, 17 Oct 2007 20:21:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Anton Vorontsov <avorontsov@ru.mvista.com>
CC: leoli@freescale.com, paulus@samba.org, galak@kernel.crashing.org,
       afleming@freescale.com, apw@shadowen.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][NET] gianfar: fix obviously wrong #ifdef CONFIG_GFAR_NAPI
 placement
References: <20071017195746.GA15592@localhost.localdomain>
In-Reply-To: <20071017195746.GA15592@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> Erroneous #ifdef introduced by 293c8513398657f6263fcdb03c87f2760cf61be4
> causing NAPI-less ethernet malfunctioning.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> Signed-off-by: Vitaly Bordug <vbordug@ru.mvista.com>

applied


