Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab0BRAQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 19:16:28 -0500
Received: from kroah.org ([198.145.64.141]:49928 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376Ab0BRAQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 19:16:21 -0500
Date: Wed, 17 Feb 2010 16:01:03 -0800
From: Greg KH <greg@kroah.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, Greg Kroah-Hartman <gregkh@suse.de>,
       Eric Biederman <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 7/8] ehci-dbgp: split PID register updates for IN and
 OUT pipes
Message-ID: <20100218000103.GI12197@kroah.com>
References: <1266014369-29547-1-git-send-email-jason.wessel@windriver.com>
 <1266014369-29547-8-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266014369-29547-8-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 04:39:28PM -0600, Jason Wessel wrote:
> This patch addresses two problems:

Do you want me to take this patch, and 8/8 in my tree, or yours?

If yours, please add a:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to the patch.

thanks,

greg k-h
