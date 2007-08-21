Return-Path: <linux-kernel-owner+w=401wt.eu-S1762185AbXHUSIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762185AbXHUSIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 14:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757583AbXHUSII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 14:08:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662AbXHUSIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 14:08:07 -0400
Date: Tue, 21 Aug 2007 11:06:31 -0700
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, kay.sievers@vrfy.org
Subject: Re: [patch 11/14] Convert from class_device to device for USB host
Message-ID: <20070821180631.GA28070@suse.de>
References: <20070820224806.154198000@suse.de> <20070820225131.546468000@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070820225131.546468000@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 03:48:17PM -0700, tonyj@suse.de wrote:
> -- 
> Content-Disposition: inline; filename=usb-host.patch
> 
> Convert from class_device to device for drivers/ide/usb/host.   Greg, not
> sure if you're looking for a patch for this. Kay mentioned maybe it was to
> be superceded by a diff mechanism.  Free free to drop if so. Thanks!

Signed-off-by: Tony Jones <tonyj@suse.de>
