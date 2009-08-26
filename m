Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbZHZMCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbZHZMCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757168AbZHZMB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:01:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58659 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756970AbZHZMB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:01:57 -0400
Date: Wed, 26 Aug 2009 13:01:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] REGULATOR Handle positive returncode from enable
Message-ID: <20090826120157.GA4548@rakim.wolfsonmicro.main>
References: <1251284044-29252-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251284044-29252-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: One Bell System - it works.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 12:54:04PM +0200, Linus Walleij wrote:
> This makes _regulator_enable() properly handle the case where
> a regulator is already on when you try to enable it. Currently
> it will erroneously handle positive return values as an error.
> 
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
