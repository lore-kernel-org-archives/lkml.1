Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbYIVL0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbYIVL0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 07:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYIVL0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 07:26:46 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:37416 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbYIVL0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 07:26:46 -0400
Subject: Re: [PATCH 2/6] regulator: Fix typo
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Zid Null <zidsoft@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <328e43f00809201317o233f0b10ybb7fb5b5278c22f2@mail.gmail.com>
References: <1221845972.6892.136.camel@odin>
	 <328e43f00809201317o233f0b10ybb7fb5b5278c22f2@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 12:26:42 +0100
Message-Id: <1222082802.10226.10.camel@dell-desktop.example.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-20 at 21:17 +0100, Zid Null wrote:
> 
> 
> 2008/9/19 Liam Girdwood <lrg@slimlogic.co.uk>
>         Fixes a small typo.
>         
>         Signed-off-by: Mark Brown
>         <broonie@opensource.wolfsonmicro.com>
>         Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>
>         ---
>          include/linux/regulator/driver.h |    2 +-
>          1 files changed, 1 insertions(+), 1 deletions(-)
>         
>         diff --git a/include/linux/regulator/driver.h
>         b/include/linux/regulator/driver.h
>         index e7cbeda..2a37528 100644
>         --- a/include/linux/regulator/driver.h
>         +++ b/include/linux/regulator/driver.h
>         @@ -51,7 +51,7 @@ struct regulator_ops {
>                                                  int output_uV, int
>         load_uA);
>         
>                /* the operations below are for configuration of
>         regulator state when
>         -        * it's parent PMIC enters a global STANBY/HIBERNATE
>         state */
>         +        * it's parent PMIC enters a global STANDBY/HIBERNATE
>         state */
> Still wrong, it's is the possesive. 
> 

Thanks. Fixed.

Liam


