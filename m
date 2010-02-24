Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab0BXLci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 06:32:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37290 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752049Ab0BXLch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 06:32:37 -0500
Date: Wed, 24 Feb 2010 11:32:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/14] Regulators: tps6507x-regulator - mark probe
 method as __devinit
Message-ID: <20100224113235.GN18896@rakim.wolfsonmicro.main>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
 <20100224073811.15964.36760.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224073811.15964.36760.stgit@localhost.localdomain>
X-Cookie: You can't take damsel here now.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 11:38:12PM -0800, Dmitry Torokhov wrote:
> Also move error handling in probe() out of line and do not bother
> to reset fields in structures that are about to be freed.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
