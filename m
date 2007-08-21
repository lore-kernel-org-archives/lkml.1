Return-Path: <linux-kernel-owner+w=401wt.eu-S1761886AbXHUPEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761886AbXHUPEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 11:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760042AbXHUPD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 11:03:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760277AbXHUPD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 11:03:57 -0400
Date: Tue, 21 Aug 2007 08:02:21 -0700
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: oakad@yahoo.com, kay.sievers@vrfy.org
Subject: Re: [patch 12/14] Convert from class_device to device for TI flash media
Message-ID: <20070821150221.GJ26519@suse.de>
References: <20070820224806.154198000@suse.de> <20070820225136.212150000@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070820225136.212150000@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 03:48:18PM -0700, tonyj@suse.de wrote:
> -- 
> Content-Disposition: inline; filename=misc.patch
> 
> Convert from class_device to device for drivers/misc/tifm.  This is
> part of the work to eliminate struct class_device.

Signed-off-by: Tony Jones <tonyj@suse.de>
