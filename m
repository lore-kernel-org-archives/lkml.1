Return-Path: <linux-kernel-owner+w=401wt.eu-S1762485AbZAHUPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762485AbZAHUPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbZAHUOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:14:53 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:50534 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbZAHUOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:14:52 -0500
Subject: Re: [PATCH] regulator: fix kernel-doc warnings
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20090108115023.e0cb3115.randy.dunlap@oracle.com>
References: <20090108115023.e0cb3115.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 20:07:59 +0000
Message-Id: <1231445279.6488.10.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 11:50 -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kernel-doc warnings in regulator/driver.h:
> 
> Warning(linux-next-20090108//include/linux/regulator/driver.h:95): Excess struct/union/enum/typedef member 'set_current' description in 'regulator_ops'
> Warning(linux-next-20090108//include/linux/regulator/driver.h:95): Excess struct/union/enum/typedef member 'get_current' description in 'regulator_ops'
> Warning(linux-next-20090108//include/linux/regulator/driver.h:124): No description found for parameter 'irq'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Liam Girdwood <lrg@slimlogic.co.uk>
> cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> -

Applied.

Thanks

Liam

