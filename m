Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYGKL5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYGKL5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbYGKL52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:57:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48897 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754522AbYGKL51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:57:27 -0400
Subject: Re: [PATCH 2/2] regulator: virtual consumer current limit support
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1215716686.17490.30.camel@localhost.localdomain>
References: <1215716686.17490.30.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 11 Jul 2008 12:57:28 +0100
Message-Id: <1215777448.6634.11.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-10 at 21:04 +0200, Philipp Zabel wrote:
> This expands the virtual consumer driver to handle current limit control
> via the min_microamps and max_microamps sysfs files.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  drivers/regulator/virtual.c |   99 +++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 96 insertions(+), 3 deletions(-)
> 

Applied.

Thanks

Liam

