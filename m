Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbYJMWKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbYJMWKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 18:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755013AbYJMWKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 18:10:24 -0400
Received: from ns2.suse.de ([195.135.220.15]:41744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbYJMWKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 18:10:24 -0400
Date: Mon, 13 Oct 2008 15:06:45 -0700
From: Greg KH <gregkh@suse.de>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 25/25] staging: at76_usb wireless driver
Message-ID: <20081013220645.GA16162@suse.de>
References: <20081013213651.GA8338@kroah.com> <1223933888-8368-2-git-send-email-greg@kroah.com> <1223934573.26245.8.camel@dv> <20081013215134.GA15880@suse.de> <1223935091.26614.0.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223935091.26614.0.camel@dv>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 05:58:11PM -0400, Pavel Roskin wrote:
> On Mon, 2008-10-13 at 14:51 -0700, Greg KH wrote:
> > On Mon, Oct 13, 2008 at 05:49:33PM -0400, Pavel Roskin wrote:
> > > On Mon, 2008-10-13 at 14:38 -0700, Greg KH wrote:
> > > > From: Pavel Roskin <proski@gnu.org>
> > > > 
> > > > Add the at76_usb wireless driver to the staging tree while the
> > > > other kernel driver (out of tree) gets rewritten to use the internal
> > > > wireless stack.
> > > > 
> > > > This patch comes directly from the Fedora kernel tree, with only the
> > > > directory placement of the files changed.
> > > > 
> > > > Signed-off-by: Pavel Roskin <proski@gnu.org>
> > > 
> > > I'm not going to support this code in any way.  I disclaim any
> > > responsibility for this code.
> > 
> > Heh, that's fine with me, but as you did write this code, I do want to
> > give you the proper credit.  I'll maintain it while it is in the staging
> > tree.
> > 
> > You might want to poke John, as his version of this patch adds your name
> > to the MAINTAINERS file in the Fedora kernels, something I don't think
> > you want to have done :)
> 
> OK, I don't care as long as I don't get any bug reports or support
> requests.

If you do, point them directly to me.

thanks,

greg k-h
