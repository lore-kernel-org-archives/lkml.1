Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbXIDPLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbXIDPLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 11:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbXIDPL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 11:11:26 -0400
Received: from gw.goop.org ([64.81.55.164]:54524 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbXIDPLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 11:11:25 -0400
Message-ID: <46DD7538.5030405@goop.org>
Date: Tue, 04 Sep 2007 16:09:44 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Massive net driver stats cleanup
References: <20070901162505.GA2944@havoc.gtf.org>
In-Reply-To: <20070901162505.GA2944@havoc.gtf.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>  drivers/net/xen-netfront.c |   26 +++--------
>   

Hey, look, its identical to the patch I have here.

Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>

    J
