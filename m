Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbZD0Ma0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbZD0Ma0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 08:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbZD0MaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 08:30:12 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:46288 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbZD0MaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 08:30:11 -0400
Subject: Re: [PATCH] regulator: add userspace-consumer driver
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
In-Reply-To: <20090427114357.GA7908@rakim.wolfsonmicro.main>
References: <20090426120036.GA10900@opensource.wolfsonmicro.com>
	 <1240753779-28189-1-git-send-email-mike@compulab.co.il>
	 <20090427114357.GA7908@rakim.wolfsonmicro.main>
Content-Type: text/plain
Date: Mon, 27 Apr 2009 13:30:09 +0100
Message-Id: <1240835409.14165.9.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-27 at 12:43 +0100, Mark Brown wrote:
> On Sun, Apr 26, 2009 at 04:49:39PM +0300, Mike Rapoport wrote:
> > The userspace-consumer driver allows control of voltage and current
> > regulator state from userspace. This is required for fine-grained
> > power management of devices that are completely controller by userspace
> > applications, e.g. a GPS transciever connected to a serial port.
> 
> > Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> 
> Looks good, though the probe() and remove() could have __devinit and
> __devexit annotations.
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Heh, just acked in time. Was about to hit enter on my keyboard ;)

Liam

