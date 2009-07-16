Return-Path: <linux-kernel-owner+w=401wt.eu-S932784AbZGPQ5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784AbZGPQ5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbZGPQ5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:57:50 -0400
Received: from senator.holtmann.net ([87.106.208.187]:55258 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584AbZGPQ5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:57:49 -0400
Subject: Re: [PATCH] imwc3200: move iwmc3200 SDIO ids to sdio_ids.h
From: Marcel Holtmann <marcel@holtmann.org>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
       "drzeus-list@drzeus.cx" <drzeus-list@drzeus.cx>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1ba2fa240907160804g18b1a215w3161c9682db7b35@mail.gmail.com>
References: <1247522953-12702-1-git-send-email-tomas.winkler@intel.com>
	 <AFAB8585072C7E48BC5C6F9C87F9B79703BA8388BB@pdsmsx502.ccr.corp.intel.com>
	 <AFAB8585072C7E48BC5C6F9C87F9B79703BA839300@pdsmsx502.ccr.corp.intel.com>
	 <1ba2fa240907160804g18b1a215w3161c9682db7b35@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 18:57:34 +0200
Message-Id: <1247763454.4549.56.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> > > Subject: RE: [PATCH] imwc3200: move iwmc3200 SDIO ids to sdio_ids.h
> >
> > BTW, subject should be "iwmc3200".
> 
> Thanks. I'll address all comments although I'm not sure how to split
> the patch since adding SDIO_VENDOR_ID_INTEL to sdio_ids.h it affects
> all the drivers anyhow, so I'm suggesting to route it through netdev.

I think it is best that you take the whole patch via net-next-2.6 to
avoid breakage during the next merge window.

Regards

Marcel


