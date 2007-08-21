Return-Path: <linux-kernel-owner+w=401wt.eu-S932092AbXHUPEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbXHUPEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 11:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761885AbXHUPEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 11:04:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:47841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761790AbXHUPEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 11:04:08 -0400
Date: Tue, 21 Aug 2007 08:02:31 -0700
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: rmk@arm.linux.org.uk, kay.sievers@vrfy.org
Subject: Re: [patch 13/14] Convert from class_device to device for UCB1x00
Message-ID: <20070821150231.GK26519@suse.de>
References: <20070820224806.154198000@suse.de> <20070820225140.739434000@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070820225140.739434000@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 03:48:19PM -0700, tonyj@suse.de wrote:
> -- 
> Content-Disposition: inline; filename=mfd.patch
> 
> Convert from class_device to device for drivers/mfd/ucb1x00.  This is
> part of the work to eliminate struct class_device.

Signed-off-by: Tony Jones <tonyj@suse.de>
