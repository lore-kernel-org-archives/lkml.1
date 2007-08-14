Return-Path: <linux-kernel-owner+w=401wt.eu-S936208AbXHNWz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936208AbXHNWz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935901AbXHNWxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:53:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47521 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935876AbXHNWxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:53:47 -0400
Date: Tue, 14 Aug 2007 15:35:57 -0700
From: Greg KH <greg@kroah.com>
To: tonyj@suse.de
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [patch 3/6] Convert from class_device to device for hwmon
Message-ID: <20070814223557.GB6375@kroah.com>
References: <20070808052842.451400000@suse.de> <20070808053022.519538000@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808053022.519538000@suse.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 10:28:45PM -0700, tonyj@suse.de wrote:
> Convert from class_device to device for hwmon_device_register/unregister
> 
> Signed-off-by: Tony Jones <tonyj@suse.de>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>

Patches 3-5 here should go through the hwmon maintainer, not me.  Feel
free to add a:
	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

to them, they look good.

thanks,

greg k-h
