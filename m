Return-Path: <linux-kernel-owner+w=401wt.eu-S1757060AbZKEOJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbZKEOJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbZKEOJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:09:53 -0500
Received: from gate.crashing.org ([63.228.1.57]:39042 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756604AbZKEOJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:09:52 -0500
Subject: Re: [PATCH 7/8] spi_mpc8xxx: Turn qe_mode into flags
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20091012164925.GG4578@oksana.dev.rtsoft.ru>
Date: Thu, 5 Nov 2009 07:47:50 -0600
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <3E303C4F-CE29-470F-B34A-3413F31BC23C@kernel.crashing.org>
References: <20091012164841.GA32214@oksana.dev.rtsoft.ru> <20091012164925.GG4578@oksana.dev.rtsoft.ru>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
X-Mailer: Apple Mail (2.1076)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 12, 2009, at 11:49 AM, Anton Vorontsov wrote:

> Soon there will be more flags introduced in subsequent patches, so
> let's turn qe_mode into flags.
>
> Also introduce mpc8xxx_spi_strmode() and print current SPI mode.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> Acked-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
> drivers/spi/spi_mpc8xxx.c   |   30 +++++++++++++++++++-----------
> include/linux/fsl_devices.h |    2 +-
> 2 files changed, 20 insertions(+), 12 deletions(-)

applied to next

- k
