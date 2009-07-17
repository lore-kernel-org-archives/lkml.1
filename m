Return-Path: <linux-kernel-owner+w=401wt.eu-S933794AbZGQAHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794AbZGQAHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933762AbZGQAHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:07:44 -0400
Received: from senator.holtmann.net ([87.106.208.187]:38234 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933737AbZGQAHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:07:41 -0400
Subject: Re: [PATCH] imwc3200: move iwmc3200 SDIO ids to sdio_ids.h
From: Marcel Holtmann <marcel@holtmann.org>
To: David Miller <davem@davemloft.net>
Cc: tomasw@gmail.com, yi.zhu@intel.com, drzeus-list@drzeus.cx,
       netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090716.130726.220404456.davem@davemloft.net>
References: <AFAB8585072C7E48BC5C6F9C87F9B79703BA839300@pdsmsx502.ccr.corp.intel.com>
	 <1ba2fa240907160804g18b1a215w3161c9682db7b35@mail.gmail.com>
	 <1247763454.4549.56.camel@violet>
	 <20090716.130726.220404456.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 02:07:26 +0200
Message-Id: <1247789246.4549.58.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> >> > > Subject: RE: [PATCH] imwc3200: move iwmc3200 SDIO ids to sdio_ids.h
> >> >
> >> > BTW, subject should be "iwmc3200".
> >> 
> >> Thanks. I'll address all comments although I'm not sure how to split
> >> the patch since adding SDIO_VENDOR_ID_INTEL to sdio_ids.h it affects
> >> all the drivers anyhow, so I'm suggesting to route it through netdev.
> > 
> > I think it is best that you take the whole patch via net-next-2.6 to
> > avoid breakage during the next merge window.
> 
> Fair enough.

after Tomas sent the revised version of course :)

Regards

Marcel


