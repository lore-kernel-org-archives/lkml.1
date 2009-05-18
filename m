Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbZERKPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbZERKPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 06:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZERKPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 06:15:20 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:36529 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZERKPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 06:15:19 -0400
Subject: Re: [PATCH] LP3971 PMIC regulator driver update
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
       Mark Brown <mark.brown@wolfsonmicro.com>
In-Reply-To: <20090515092030.GA2202@rakim.wolfsonmicro.main>
References: <E4D3F24EA6C9E54F817833EAE0D912AC02245E9A11@bssrvexch01.BS.local>
	 <20090515092030.GA2202@rakim.wolfsonmicro.main>
Content-Type: text/plain
Date: Mon, 18 May 2009 11:15:18 +0100
Message-Id: <1242641718.5473.2156.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-15 at 10:20 +0100, Mark Brown wrote:
> On Fri, May 15, 2009 at 11:16:19AM +0200, Marek Szyprowski wrote:
> > This patch fixes issues reported by Mark Brown in his review of National Semiconductors LP3971
> > PMIC regulator driver. It contains:
> > - a little code cleanup
> > - list_voltage() callback added
> 
> > Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> Looks good.
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Doesn't apply :-

Applying: LP3971 PMIC regulator driver update
error: patch failed: drivers/regulator/lp3971.c:91
error: drivers/regulator/lp3971.c: patch does not apply
Patch failed at 0001 LP3971 PMIC regulator driver update

Could you regenerate against the voltage for-next branch.

Thanks

Liam

