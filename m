Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbZG0Jha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbZG0Jha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 05:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755777AbZG0Jh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 05:37:29 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:50047 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903AbZG0Jh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 05:37:27 -0400
Subject: Re: [PATCH] regulator: da903x: add support for DA9030 BUCK2 with
 DVM
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mike Rapoport <mike@compulab.co.il>
Cc: broonie@opensource.wolfsonmicro.com, eric.y.miao@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <4A6C313C.9050101@compulab.co.il>
References: <1248594842-23456-1-git-send-email-mike@compulab.co.il>
	 <1248601239.25964.883.camel@vega.slimlogic.co.uk>
	 <4A6C313C.9050101@compulab.co.il>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 10:37:25 +0100
Message-Id: <1248687445.25964.977.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-26 at 13:34 +0300, Mike Rapoport wrote:

> 
> > From: Mike Rapoport <mike@compulab.co.il>
> Date: Sun, 26 Jul 2009 13:33:04 +0300
> Subject: [PATCH] regulator: da903x: consolidate DA903[045]_DVC macros
> 
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> ---
>  drivers/regulator/da903x.c |   66 +++++++++++--------------------------------
>  1 files changed, 17 insertions(+), 49 deletions(-)
> 

Applied.

Thanks

Liam

