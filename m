Return-Path: <linux-kernel-owner+w=401wt.eu-S933236AbZGPUHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbZGPUHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 16:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933193AbZGPUHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 16:07:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42375
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933192AbZGPUHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 16:07:22 -0400
Date: Thu, 16 Jul 2009 13:07:26 -0700 (PDT)
Message-Id: <20090716.130726.220404456.davem@davemloft.net>
To: marcel@holtmann.org
Cc: tomasw@gmail.com, yi.zhu@intel.com, drzeus-list@drzeus.cx,
       netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] imwc3200: move iwmc3200 SDIO ids to sdio_ids.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1247763454.4549.56.camel@violet>
References: <AFAB8585072C7E48BC5C6F9C87F9B79703BA839300@pdsmsx502.ccr.corp.intel.com>
	<1ba2fa240907160804g18b1a215w3161c9682db7b35@mail.gmail.com>
	<1247763454.4549.56.camel@violet>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>
Date: Thu, 16 Jul 2009 18:57:34 +0200

> Hi Dave,
> 
>> > > Subject: RE: [PATCH] imwc3200: move iwmc3200 SDIO ids to sdio_ids.h
>> >
>> > BTW, subject should be "iwmc3200".
>> 
>> Thanks. I'll address all comments although I'm not sure how to split
>> the patch since adding SDIO_VENDOR_ID_INTEL to sdio_ids.h it affects
>> all the drivers anyhow, so I'm suggesting to route it through netdev.
> 
> I think it is best that you take the whole patch via net-next-2.6 to
> avoid breakage during the next merge window.

Fair enough.
