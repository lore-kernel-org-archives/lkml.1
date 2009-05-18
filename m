Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZERKKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZERKKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 06:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbZERKKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 06:10:13 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:38701 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbZERKKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 06:10:12 -0400
Subject: Re: [PATCH] LP3971 PMIC regulator driver
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
       "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
In-Reply-To: <E4D3F24EA6C9E54F817833EAE0D912AC02245E982A@bssrvexch01.BS.local>
References: <E4D3F24EA6C9E54F817833EAE0D912AC02245E982A@bssrvexch01.BS.local>
Content-Type: text/plain
Date: Mon, 18 May 2009 11:10:09 +0100
Message-Id: <1242641409.5473.2153.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-14 at 09:33 +0200, Marek Szyprowski wrote:
> This patch adds regulator drivers for National Semiconductors LP3971 PMIC.
> This LP3971 PMIC controller has 3 DC/DC voltage converters and 5 low drop-out
> (LDO) regulators. LP3971 PMIC controller uses I2C interface.
> 
> Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Applied, after a little Makefile/Kconfig merging. In the future, please
could you generate any patches against the voltage for-next branch:-

git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git

Thanks

Liam

