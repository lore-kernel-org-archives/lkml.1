Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZGBOHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZGBOHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 10:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbZGBOGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 10:06:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41770 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752450AbZGBOGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 10:06:52 -0400
Date: Thu, 2 Jul 2009 15:06:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: avorontsov@ru.mvista.com, cbou@mail.ru, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, richard@laptop.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: Re: [PATCH 5/5] power_supply: add a charge_type status to the api,
 and use it for olpc driver
Message-ID: <20090702140653.GA3558@rakim.wolfsonmicro.main>
References: <20090630021730.44f86185@mycelium.queued.net>
 <20090630231450.GD12076@oksana.dev.rtsoft.ru>
 <20090702094518.3d44eca3@mycelium.queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702094518.3d44eca3@mycelium.queued.net>
X-Cookie: Leave no stone unturned.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 09:45:18AM -0400, Andres Salomon wrote:

> This adds a new sysfs file called 'charge_type' which displays the type of
> charging (unknown, n/a, trickle charge, or fast charging).  This allows
> things like battery diagnostics to determine what the battery/EC is doing
> without resorting to changing the 'status' sysfs output.
> 
> Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
