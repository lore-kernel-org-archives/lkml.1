Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbZCLKyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbZCLKyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbZCLKyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:54:33 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:36538 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbZCLKyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:54:32 -0400
Subject: Re: [PATCH] regulator: Don't warn if we failed to get a regulator
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1236814552-21436-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1236814552-21436-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 10:54:28 +0000
Message-Id: <1236855268.6781.201.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 23:35 +0000, Mark Brown wrote:
> The consumer can print a message if required, some consumers may have
> optional regulators and wish to downgrade the logging for them or ignore
> their absence.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 

Applied.

Thanks

Liam

