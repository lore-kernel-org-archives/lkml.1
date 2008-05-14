Return-Path: <linux-kernel-owner+w=401wt.eu-S1761497AbYENTBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497AbYENTBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 15:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbYENTBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 15:01:30 -0400
Received: from server.drzeus.cx ([85.8.24.28]:59934 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754204AbYENTBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 15:01:30 -0400
Date: Wed, 14 May 2008 21:01:05 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>,
       Anderson Briglia <anderson.briglia@indt.org.br>,
       Syed Khasim <sm.khasim@gmail.com>
Subject: Re: [PATCH] MMC: Fix omap compile by replacing dev_name with
 dma_dev_name
Message-ID: <20080514210105.6e7827c1@mjolnir.drzeus.cx>
In-Reply-To: <20080506233647.GL18682@atomide.com>
References: <20080506233647.GL18682@atomide.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 16:36:47 -0700
Tony Lindgren <tony@atomide.com> wrote:

> Hi Pierre,
> 
> Here's a fix to make omap.c compile again because of a name conflict
> introduced by 3efcdd76c4906236f9043c8b34837818177b291d.
> 
> Regards,
> 
> Tony


applied, thanks

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
