Return-Path: <linux-kernel-owner+w=401wt.eu-S1759132AbZDSIf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132AbZDSIf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 04:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbZDSIfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 04:35:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40015
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751966AbZDSIfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 04:35:15 -0400
Date: Sun, 19 Apr 2009 01:35:04 -0700 (PDT)
Message-Id: <20090419.013504.175627328.davem@davemloft.net>
To: g.liakhovetski@gmx.de
Cc: florian@openwrt.org, peter@holik.at, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb driver for intellon based PLC like devolo dlan duo
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0904191025060.4369@axis700.grange>
References: <Pine.LNX.4.64.0904182146220.14879@axis700.grange>
	<20090418.211503.13481677.davem@davemloft.net>
	<Pine.LNX.4.64.0904191025060.4369@axis700.grange>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Sun, 19 Apr 2009 10:32:24 +0200 (CEST)

> Ok, we currently have drivers for mt9m001, mt9m111, mt9t031, and mt9v022. 
> Which letter would you take for them?:-) You'd have to take at least two 
> characters like "m0", "m1", "t0", and "v0" but that wouldn't be very 
> intuitive IMHO either. Take four characters like m001r16() and it looks 
> pretty bad compared to all routines being called mt9m001_*.

Then mt9m001_FOO() is what you use if you know that such other
similar names exist.
