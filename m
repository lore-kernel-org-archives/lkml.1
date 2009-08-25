Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZHYRtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZHYRtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 13:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755476AbZHYRtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 13:49:23 -0400
Received: from kroah.org ([198.145.64.141]:49063 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441AbZHYRtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 13:49:22 -0400
Date: Tue, 25 Aug 2009 10:47:52 -0700
From: Greg KH <greg@kroah.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH V4 1/2] introduce ALS sysfs class
Message-ID: <20090825174752.GB22984@kroah.com>
References: <1251184693.3483.95.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1251184693.3483.95.camel@rzhang-dt>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 03:18:13PM +0800, Zhang Rui wrote:
> 
> ﻿Introduce ALS sysfs class.
> 
> ALS sysfs class provides a standard sysfs interface for
> Ambient Light Sensor devices.
> 
> please read Documentation/ABI/testing/sysfs-class-als for
> detailed sysfs designs.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks for the documentation changes.

greg k-h
