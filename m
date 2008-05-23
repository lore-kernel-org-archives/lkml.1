Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbYEWOOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbYEWOOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 10:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYEWOO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 10:14:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54319 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751269AbYEWOO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 10:14:28 -0400
Date: Fri, 23 May 2008 15:14:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, liam.girdwood@wolfsonmicro.com
Subject: Re: wm97xx-core: wrong driver name?
Message-ID: <20080523141426.GA16294@opensource.wolfsonmicro.com>
Mail-Followup-To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@vger.kernel.org, liam.girdwood@wolfsonmicro.com
References: <Pine.LNX.4.64.0805231551140.5494@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805231551140.5494@axis700.grange>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 04:02:42PM +0200, Guennadi Liakhovetski wrote:

> is this device_driver initialisation in 
> drivers/input/touchscreen/wm97xx-core.c really correct (see "name")?

No, it should be something else.  I'll fix this - thanks for the report.
