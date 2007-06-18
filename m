Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbXFRG1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbXFRG1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 02:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbXFRG1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 02:27:42 -0400
Received: from brick.kernel.dk ([80.160.20.94]:21783 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbXFRG1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 02:27:41 -0400
Date: Mon, 18 Jun 2007 08:27:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cdrom_sysctl_info fix
Message-ID: <20070618062722.GP6149@kernel.dk>
References: <20070614142430.GA2388@darkstar.te-china.tietoenator.com> <20070615132657.GW6149@kernel.dk> <20070618125811.GA1692@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618125811.GA1692@darkstar.te-china.tietoenator.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18 2007, Dave Young wrote:
> I rewite the patch according to yours, please help to check. Pass the
> cdrom_print_info function one more argument for diffrent type
> printing, do you have better solutions for this? thanks for replying
> :)

Yep that looks much better! I trust you booted and tested this and the
output looks correct?

-- 
Jens Axboe

