Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbYFZJBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbYFZJBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbYFZJBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:01:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:38941 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbYFZJBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:01:16 -0400
Subject: Re: [PATCH 1/4] ide-pmac: media-bay support fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200806261051.34733.bzolnier@gmail.com>
References: <200806162124.43005.bzolnier@gmail.com>
	 <200806242055.12042.bzolnier@gmail.com> <1214456094.8011.438.camel@pasglop>
	 <200806261051.34733.bzolnier@gmail.com>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 19:01:08 +1000
Message-Id: <1214470868.8011.455.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-26 at 10:51 +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> The latest patches in one place:
> 
> http://www.kernel.org/pub/linux/kernel/people/bart/pata-2.6/
> 
> pmac-media-bay-support-fixes-take-3.patch
> pmac-store-pmif-instead-of-hwif-in-driver_data-take-2.patch
> pmac-add-init_dev-method-take-3.patch
> pmac-move-ide_find_port-call-to-pmac_ide_setup_device-take-2.patch
> 
> IMO they are quite small and straightforward so setting git tree would
> be overdoing it but if there are still problems I will set one.

That's ok, just tell me a tree and an SHA1 ID of a commit on top of
which they apply, that will make my life easier :-)

I'll test them tomorrow morning.

Cheers,
Ben.


