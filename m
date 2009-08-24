Return-Path: <linux-kernel-owner+w=401wt.eu-S1751886AbZHXISu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbZHXISu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbZHXISu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:18:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:41540 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbZHXISt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:18:49 -0400
Date: Mon, 24 Aug 2009 10:18:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Michael Buesch <mb@bu3sch.de>
Cc: Peter Huewe <PeterHuewe@gmx.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] gpio: adding __init/__exit macros in
 drivers/gpio/bt8xxgpio.c
In-Reply-To: <200908230206.57937.mb@bu3sch.de>
Message-ID: <alpine.LNX.2.00.0908241018380.25797@wotan.suse.de>
References: <200908230201.10471.PeterHuewe@gmx.de> <200908230206.57937.mb@bu3sch.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Aug 2009, Michael Buesch wrote:

> > Trivial patch which adds the __init/__exit macro to the init/exit functions of
> > drivers/gpio/bt8xxgpio.c
> > 
> > Michael, Kay or Greg, please have a look at the small patch and either pull it
> > through your tree, or please ack' it so Jiri can pull it through the trivial
> > tree.
> > 
> > linux version 2.6.31-rc7 - linus git tree, So 23. Aug 01:38:43 CEST 2009
> > 
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> 
> Acked-by: Michael Buesch <mb@bu3sch.de>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
