Return-Path: <linux-kernel-owner+w=401wt.eu-S1757855AbZHGMxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbZHGMxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 08:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757846AbZHGMxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 08:53:39 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:39886 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021AbZHGMxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 08:53:39 -0400
Subject: Re: [PATCH v5] [RESEND 2] regulator: Add GPIO enable control to
 fixed voltage regulator driver
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Roger Quadros <quadros.roger@gmail.com>
Cc: broonie@sirena.org.uk, philipp.zabel@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1249576649-10906-1-git-send-email-quadros.roger@gmail.com>
References: <quadros.roger@gmail.com>
	 <1249576649-10906-1-git-send-email-quadros.roger@gmail.com>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 13:53:37 +0100
Message-Id: <1249649617.4370.253.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 19:37 +0300, Roger Quadros wrote:
> From: Roger Quadros <ext-roger.quadros@nokia.com>
> 
> Now fixed regulators that have their enable pin connected to a GPIO line
> can use the fixed regulator driver for regulator enable/disable control.
> The GPIO number and polarity information is passed through platform data.
> GPIO enable control is achieved using gpiolib.
> 
> Signed-off-by: Roger Quadros <ext-roger.quadros@nokia.com>
> Reviewed-by: Philipp Zabel <philipp.zabel@gmail.com>
> Reviewed-by: Felipe Balbi <felipe.balbi@nokia.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/fixed.c       |   88 ++++++++++++++++++++++++++++++++++++++-
>  include/linux/regulator/fixed.h |   24 +++++++++++
>  2 files changed, 110 insertions(+), 2 deletions(-)
> 

Applied.

Thanks

Liam

