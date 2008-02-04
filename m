Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbYBDRMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbYBDRMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 12:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbYBDRL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 12:11:58 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50018 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbYBDRL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 12:11:57 -0500
Date: Mon, 4 Feb 2008 09:10:08 -0800
From: Greg KH <greg@kroah.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Basic braille screen reader support
Message-ID: <20080204171008.GA22050@kroah.com>
References: <20080204031842.GE4439@implementation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204031842.GE4439@implementation>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 03:18:43AM +0000, Samuel Thibault wrote:
> This adds a minimalistic braille screen reader support.
> This is meant to be used by blind people e.g. on boot failures or when /
> cannot be mounted etc and thus the userland screen readers can not work.

Will this api work with the SpeakUp kernel drivers?  Are the hooks
sufficient for what those drivers are expecting?

> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org

You forgot a trailing '>'  :)

thanks,

greg k-h
