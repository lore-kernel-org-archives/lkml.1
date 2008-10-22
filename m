Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbYJVRuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbYJVRuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758881AbYJVRnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:43:40 -0400
Received: from kroah.org ([198.145.64.141]:49739 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757888AbYJVRnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:43:39 -0400
Date: Wed, 22 Oct 2008 10:40:04 -0700
From: Greg KH <greg@kroah.com>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Add c2 port support.
Message-ID: <20081022174004.GB10587@kroah.com>
References: <1224683240-15439-1-git-send-email-giometti@linux.it> <1224683240-15439-2-git-send-email-giometti@linux.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224683240-15439-2-git-send-email-giometti@linux.it>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 03:47:19PM +0200, Rodolfo Giometti wrote:
> C2port implements a two wire serial communication protocol (bit
> banging) designed to enable in-system programming, debugging, and
> boundary-scan testing on low pin-count Silicon Labs devices.
> 
> Currently this code supports only flash programming through sysfs
> interface but extensions shoud be easy to add.
> 
> Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Nice job.

Andrew, no reason why these 2 patches can't go into 2.6.28, they are
self-contained and are new drivers.

Do you want to send them to Linus, or want me to?

thanks,

greg k-h
