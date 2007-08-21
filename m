Return-Path: <linux-kernel-owner+w=401wt.eu-S1762305AbXHUPDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762305AbXHUPDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 11:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbXHUPDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 11:03:10 -0400
Received: from ns.suse.de ([195.135.220.2]:37024 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759522AbXHUPDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 11:03:08 -0400
Date: Tue, 21 Aug 2007 08:01:32 -0700
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, kay.sievers@vrfy.org
Subject: Re: [patch 10/14] Convert from class_device to device for USB core
Message-ID: <20070821150132.GI26519@suse.de>
References: <20070820224806.154198000@suse.de> <20070820225127.423095000@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070820225127.423095000@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 03:48:16PM -0700, tonyj@suse.de wrote:
> -- 
> Content-Disposition: inline; filename=usb-core.patch
> 
> Convert from class_device to device for drivers/ide/usb/core.   Greg, not
> sure if you're looking for a patch for this. Kay mentioned maybe it was to
> be superceded by a diff mechanism.  Free free to drop if so.

Signed-off-by: Tony Jones <tonyj@suse.de>
