Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbZCDLmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbZCDLmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZCDLl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:41:59 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:37107 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbZCDLl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:41:59 -0500
Subject: Re: [PATCH 2/2] regulator: Implement list_voltage for WM835x LDOs
 and DCDCs
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1236011567-31311-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1236011567-31311-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1236011567-31311-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 11:41:56 +0000
Message-Id: <1236166916.6781.3.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 16:32 +0000, Mark Brown wrote:
> Implement the recently added voltage step listing API for the WM835x
> DCDCs and LDOs. DCDCs can use values up to 0x66, LDOs can use the full
> range of values in the mask. Both masks are the lower bits of the
> register.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/wm8350-regulator.c |   29 +++++++++++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)
> 

Applied.

Thanks

Liam

