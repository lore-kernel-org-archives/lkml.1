Return-Path: <linux-kernel-owner+w=401wt.eu-S1751421AbZJSA6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbZJSA6o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 20:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbZJSA6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 20:58:43 -0400
Received: from kroah.org ([198.145.64.141]:49224 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbZJSA6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 20:58:43 -0400
Date: Sun, 18 Oct 2009 17:02:21 -0700
From: Greg KH <greg@kroah.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/7] usb: trivial cleanups
Message-ID: <20091019000221.GA23405@kroah.com>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com> <1255906474-25091-2-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255906474-25091-2-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 01:54:28AM +0300, Felipe Contreras wrote:
> It seems 'min_t' was used before, and looks cleaner, plus white-space
> stuff.
> 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

But this doesn't fix a kernel warning, does it?  If so, what one?

thanks,

greg k-h
