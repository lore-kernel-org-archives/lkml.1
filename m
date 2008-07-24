Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbYGXFnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbYGXFnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 01:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYGXFmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 01:42:54 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:27641 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbYGXFmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 01:42:54 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-10.tower-164.messagelabs.com!1216878173!13030628!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Thu, 24 Jul 2008 07:42:49 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Ingo Oeser <ioe-lkml@rameria.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] set_irq_wake: fix return code and wake status tracking
Message-ID: <20080724054249.GB9049@digi.com>
References: <1216816945-20223-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <200807232044.15049.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807232044.15049.ioe-lkml@rameria.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 24 Jul 2008 05:42:49.0767 (UTC) FILETIME=[1BAEDB70:01C8ED50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

Ingo Oeser wrote:
> you can mark the new function static.
Right, good catch.  As this patch already hit mainline I will send a
followup.

Thanks,
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
