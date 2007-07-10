Return-Path: <linux-kernel-owner+w=401wt.eu-S1761779AbXGJQu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761779AbXGJQu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbXGJQuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:50:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42207 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754381AbXGJQuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:50:14 -0400
Date: Tue, 10 Jul 2007 09:49:54 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Adrian Bunk <bunk@stusta.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] the scheduled sk98lin removal
Message-ID: <20070710094954.788aa357@freepuppy.rosehill.hemminger.net>
In-Reply-To: <4693B773.2080205@garzik.org>
References: <20070709145916.GE3492@stusta.de>
	<4693B773.2080205@garzik.org>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 12:44:35 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Adrian Bunk wrote:
> > This patch contains the scheduled removal of the sk98lin driver.
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> Stephen -- ACK?

Yes.  Existing driver is dead, if there are any ancient boards that don't
work with skge, I haven't heard any complaints in at least a year.
As a fallback users, can always go with vendor driver.
