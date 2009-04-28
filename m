Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbZD1NYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbZD1NYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759842AbZD1NY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:24:29 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:48962 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759769AbZD1NY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:24:28 -0400
Subject: Re: [PATCH 2/2] regulator: Set MODULE_ALIAS for regulator drivers
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1240913635-22404-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1240913635-22404-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1240913635-22404-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 14:24:26 +0100
Message-Id: <1240925066.14165.146.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 11:13 +0100, Mark Brown wrote:
> Several of the regulator drivers didn't have MODULE_ALIAS so couldn't be
> auto loaded. Add the MODULE_ALIAS in case they do get built as modules.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/fixed.c            |    1 +
>  drivers/regulator/virtual.c          |    1 +
>  drivers/regulator/wm8350-regulator.c |    1 +
>  3 files changed, 3 insertions(+), 0 deletions(-)
> 

Applied.

Thanks

Liam

