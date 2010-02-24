Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab0BXKG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 05:06:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40313 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756234Ab0BXKG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 05:06:56 -0500
Date: Wed, 24 Feb 2010 10:06:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/14] Regulators: max1586 - annotate probe and remove
 methods
Message-ID: <20100224100654.GD18896@rakim.wolfsonmicro.main>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
 <20100224073822.15964.51065.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224073822.15964.51065.stgit@localhost.localdomain>
X-Cookie: You can't take damsel here now.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 11:38:23PM -0800, Dmitry Torokhov wrote:
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

>  	.driver		= {
>  		.name	= "max1586",
> +		.owner	= THIS_MODULE,
>  	},

Note that a large number of your patches introduce this change and none
of them note it in the changelog...
