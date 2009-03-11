Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbZCKAcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbZCKAcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZCKAcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:32:03 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:51229 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbZCKAcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:32:01 -0400
Date: Wed, 11 Mar 2009 01:31:55 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Added driver for ISL29003 ambient light sensor
Message-ID: <20090311003155.GB21160@buzzloop.caiaq.de>
References: <20090306160042.GA17800@buzzloop.caiaq.de> <20090306182432.338b0244@hyperion.delvare> <20090306181409.GA20135@buzzloop.caiaq.de> <20090307115449.32f0ab26@hyperion.delvare> <20090307120631.GA25276@buzzloop.caiaq.de> <20090307130818.367bcaad@hyperion.delvare> <20090309210901.GC31367@buzzloop.caiaq.de> <49B666F9.50209@cam.ac.uk> <20090310151542.GE9564@buzzloop.caiaq.de> <49B6A843.3090902@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B6A843.3090902@cam.ac.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 05:49:55PM +0000, Jonathan Cameron wrote:
> >>From 8ee5021834900f312ff26cd2586c18e99af31a5d Mon Sep 17 00:00:00 2001
> > From: Daniel Mack <daniel@caiaq.de>
> > Date: Tue, 10 Mar 2009 16:13:07 +0100
> > Subject: [PATCH] Added driver for ISL29003 ambient light sensor
> > 
> > This patch adds a driver for Intersil's ISL29003 ambient light sensor
> > device plus some documentation. Inspired by tsl2550.c, a driver for a
> > similar device.
> > 
> > It is put to drivers/misc for now until the industrial I/O framework
> > gets merged.
> > 
> > Signed-off-by: Daniel Mack <daniel@caiaq.de>

[...]

> All looks fine to me.
> 
> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

Ok, wonderful :)

What's the merge path for that, who'll queue it?

Thanks,
Daniel

