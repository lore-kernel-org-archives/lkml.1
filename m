Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbYLLTit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbYLLTit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYLLTiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:38:16 -0500
Received: from kroah.org ([198.145.64.141]:37864 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753110AbYLLTiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:38:12 -0500
Date: Fri, 12 Dec 2008 11:08:15 -0800
From: Greg KH <greg@kroah.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Greg KH <gregkh@suse.de>, Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] dynamic_printk: add line feed to printk
Message-ID: <20081212190815.GC2950@kroah.com>
References: <20081210073347.GA18737@localhost> <1228904326.19553.127.camel@violet.holtmann.net> <20081210144058.GA11842@localhost> <20081210152323.GB446@suse.de> <20081210234317.GA5904@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081210234317.GA5904@localhost>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 07:43:17AM +0800, Wu Fengguang wrote:
> On Wed, Dec 10, 2008 at 05:23:23PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Dec 10, 2008 at 10:40:58PM +0800, Wu Fengguang wrote:
> > > On Wed, Dec 10, 2008 at 12:18:46PM +0200, Marcel Holtmann wrote:
> > > > Hi,
> > > > 
> > > > > Append '\n' to two printk messages.
> > > > 
> > > > I already sent a patch for that and Greg picked it up.
> > > 
> > > No I didn't find it in the usb-2.6 tree:
> > > 
> > > git pull git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6.git
> > > >From git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6
> > >  * branch            HEAD       -> FETCH_HEAD
> > > Already up-to-date.
> > 
> > That's not the "usb" tree, if you read the description, it should be
> > clear.
> 
> Yup, it reads "junk tree, please ignore". When I first found it in
> git.kernel.org, I chose to trust the name 'usb-2.6' instead of its
> description...

Heh, as if I just added that description for the fun of it :)

> > My tree is in quilt, please see the MAINTAINERS file for details.
> 
> Got it. Below is the updated patch based on Marcel's one.

Thanks, I'll queue it up.

grg k-h
