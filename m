Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbZBTKoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbZBTKoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 05:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbZBTKoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 05:44:05 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:48596 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800AbZBTKoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 05:44:04 -0500
Subject: Re: [PATCH] regulator: Suggest use of datasheet supply or pin
 names for consumers
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1234366326-32148-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1234366326-32148-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 10:43:59 +0000
Message-Id: <1235126639.27887.372.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-11 at 15:32 +0000, Mark Brown wrote:
> Update the documentation to suggest the use of datasheet names for
> the supplies requested by regulator consumers. Doing this makes it
> easier to tie the design for a given platform up with the requirements
> of the driver for a consumer.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 

Applied.

Thanks

Liam

