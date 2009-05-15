Return-Path: <linux-kernel-owner+w=401wt.eu-S1761383AbZEOJUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383AbZEOJUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 05:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbZEOJUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 05:20:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46723 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757027AbZEOJUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 05:20:31 -0400
Date: Fri, 15 May 2009 10:20:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "'Liam Girdwood'" <lrg@slimlogic.co.uk>,
       "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Subject: Re: [PATCH] LP3971 PMIC regulator driver update
Message-ID: <20090515092030.GA2202@rakim.wolfsonmicro.main>
References: <E4D3F24EA6C9E54F817833EAE0D912AC02245E9A11@bssrvexch01.BS.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E4D3F24EA6C9E54F817833EAE0D912AC02245E9A11@bssrvexch01.BS.local>
X-Cookie: So much food
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 11:16:19AM +0200, Marek Szyprowski wrote:
> This patch fixes issues reported by Mark Brown in his review of National Semiconductors LP3971
> PMIC regulator driver. It contains:
> - a little code cleanup
> - list_voltage() callback added

> Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Looks good.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
