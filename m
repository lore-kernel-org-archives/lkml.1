Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbZKEOGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbZKEOGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756978AbZKEOGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:06:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:38966 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756971AbZKEOGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:06:35 -0500
Subject: Re: [PATCH 6/8] spi_mpc8xxx: Factor out SPI mode change steps into a call
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20091012164924.GF4578@oksana.dev.rtsoft.ru>
Date: Thu, 5 Nov 2009 07:47:21 -0600
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <B265B3EB-6F4F-45FB-98E8-39C9B03572B9@kernel.crashing.org>
References: <20091012164841.GA32214@oksana.dev.rtsoft.ru> <20091012164924.GF4578@oksana.dev.rtsoft.ru>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
X-Mailer: Apple Mail (2.1076)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 12, 2009, at 11:49 AM, Anton Vorontsov wrote:

> We'll add more steps soon, so get rid of the duplication.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> Acked-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
> drivers/spi/spi_mpc8xxx.c |   56 ++++++++++++++++++ 
> +-------------------------
> 1 files changed, 24 insertions(+), 32 deletions(-)

applied to next

- k
