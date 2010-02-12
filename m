Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab0BLLUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 06:20:54 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:61068 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab0BLLUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 06:20:53 -0500
Subject: Re: [PATCH] regulator: Assume regulators are enabled if they don't
 report anything
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1265908965-7726-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1265908965-7726-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Feb 2010 11:20:47 +0000
Message-ID: <1265973647.3231.2.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-11 at 17:22 +0000, Mark Brown wrote:
> If a regulator driver does not provide a way to query if the driver is
> enabled then assume that it is enabled.  This is very likely to reflect
> the actual state is more useful for callers than reporting an error.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---

Applied.

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

