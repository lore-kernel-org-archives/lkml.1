Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbZBZUQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbZBZUQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 15:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbZBZUQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 15:16:01 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:37821 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZBZUQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 15:16:00 -0500
Subject: Re: [PATCH 1/2] regulator: Allow regulators to set the initial
 operating mode
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1235676260-19696-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1235676260-19696-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 20:15:57 +0000
Message-Id: <1235679357.31223.49.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 19:24 +0000, Mark Brown wrote:
> This is useful when wishing to run in a fixed operating mode that isn't
> the default.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c          |   17 +++++++++++++++++
>  include/linux/regulator/machine.h |    4 ++++
>  2 files changed, 21 insertions(+), 0 deletions(-)
> 

Applied.

Thanks

Liam

