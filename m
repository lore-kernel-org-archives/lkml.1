Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbYLJP1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbYLJP1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 10:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYLJP1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 10:27:40 -0500
Received: from ns2.suse.de ([195.135.220.15]:54273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbYLJP1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 10:27:39 -0500
Date: Wed, 10 Dec 2008 07:23:23 -0800
From: Greg KH <gregkh@suse.de>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, LKML <linux-kernel@vger.kernel.org>,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] dynamic_printk: add line feed to printk
Message-ID: <20081210152323.GB446@suse.de>
References: <20081210073347.GA18737@localhost> <1228904326.19553.127.camel@violet.holtmann.net> <20081210144058.GA11842@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081210144058.GA11842@localhost>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 10:40:58PM +0800, Wu Fengguang wrote:
> On Wed, Dec 10, 2008 at 12:18:46PM +0200, Marcel Holtmann wrote:
> > Hi,
> > 
> > > Append '\n' to two printk messages.
> > 
> > I already sent a patch for that and Greg picked it up.
> 
> No I didn't find it in the usb-2.6 tree:
> 
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6.git
> >From git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6
>  * branch            HEAD       -> FETCH_HEAD
> Already up-to-date.

That's not the "usb" tree, if you read the description, it should be
clear.

My tree is in quilt, please see the MAINTAINERS file for details.

thanks,

greg k-h
