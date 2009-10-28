Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZJ1Qrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZJ1Qrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 12:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbZJ1Qrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 12:47:46 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:48521 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbZJ1Qrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 12:47:46 -0400
Subject: Re: [PATCH] Fix some AB3100 regulator issues
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1256747415-18486-1-git-send-email-linus.walleij@stericsson.com>
References: <1256747415-18486-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Oct 2009 16:47:43 +0000
Message-ID: <1256748463.3586.125.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 17:30 +0100, Linus Walleij wrote:
> This patch will remove surplus register writes on shut down of
> LDO D (this magic was not needed), remove an unnecessary (!) error
> check and really unregister the regulators when the module is
> unloaded.
> 
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>

Thanks.

Applied.

Liam

