Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbYHTU7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbYHTU7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 16:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756881AbYHTU7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 16:59:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:48354 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786AbYHTU7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 16:59:16 -0400
Date: Wed, 20 Aug 2008 13:41:13 -0700
From: Greg KH <greg@kroah.com>
To: Will Newton <will.newton@imgtec.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       leoli@freescale.com
Subject: Re: [PATCH 05/11] fsl_usb2_udc: Clean up whitespace in /proc
	debugging output.
Message-ID: <20080820204113.GA11328@kroah.com>
References: <1218551957-17091-1-git-send-email-will.newton@imgtec.com> <1218551957-17091-2-git-send-email-will.newton@imgtec.com> <1218551957-17091-3-git-send-email-will.newton@imgtec.com> <1218551957-17091-4-git-send-email-will.newton@imgtec.com> <1218551957-17091-5-git-send-email-will.newton@imgtec.com> <1218551957-17091-6-git-send-email-will.newton@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218551957-17091-6-git-send-email-will.newton@imgtec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 03:39:11PM +0100, Will Newton wrote:
> Missing spaces were causing the /proc debugging output to be rather
> unreadable.

Can you just move this file to debugfs please?

No driver should ever be putting anything into proc files anymore.

thanks,

greg k-h
