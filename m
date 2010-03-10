Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab0CJRHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:07:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56228 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932478Ab0CJRHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:07:20 -0500
Date: Wed, 10 Mar 2010 17:07:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: axel lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>, lrg@slimlogic.co.uk
Subject: Re: [PATCH] Regulators: lp3971 - Fix setting val for LDO2 and LDO4
Message-ID: <20100310170717.GC22626@rakim.wolfsonmicro.main>
References: <427d64721003091629s4c5728b4y9005feeef9a05b7e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <427d64721003091629s4c5728b4y9005feeef9a05b7e@mail.gmail.com>
X-Cookie: Love means nothing to a tennis player.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 08:29:40AM +0800, axel lin wrote:
> From: Axel Lin <axel.lin@gmail.com>
> Date: Tue, 9 Mar 2010 16:53:59 +0800
> Subject: [PATCH] lp3971: Fix setting val for LDO2 and LDO4
> 
> In lp3971_ldo_set_voltage function, it requires val to left shift 4
> bits for LDO2 and LDO4.
> This patch fix this issue.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but I really would prefer to see one of the Samsung folks comment.
