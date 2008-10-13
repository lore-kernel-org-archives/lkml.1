Return-Path: <linux-kernel-owner+w=401wt.eu-S1757942AbYJMV6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbYJMV6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbYJMV6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:58:14 -0400
Received: from c60.cesmail.net ([216.154.195.49]:53906 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbYJMV6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:58:14 -0400
Subject: Re: [PATCH 25/25] staging: at76_usb wireless driver
From: Pavel Roskin <proski@gnu.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20081013215134.GA15880@suse.de>
References: <20081013213651.GA8338@kroah.com>
	 <1223933888-8368-2-git-send-email-greg@kroah.com>
	 <1223934573.26245.8.camel@dv>  <20081013215134.GA15880@suse.de>
Content-Type: text/plain
Date: Mon, 13 Oct 2008 17:58:11 -0400
Message-Id: <1223935091.26614.0.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-13 at 14:51 -0700, Greg KH wrote:
> On Mon, Oct 13, 2008 at 05:49:33PM -0400, Pavel Roskin wrote:
> > On Mon, 2008-10-13 at 14:38 -0700, Greg KH wrote:
> > > From: Pavel Roskin <proski@gnu.org>
> > > 
> > > Add the at76_usb wireless driver to the staging tree while the
> > > other kernel driver (out of tree) gets rewritten to use the internal
> > > wireless stack.
> > > 
> > > This patch comes directly from the Fedora kernel tree, with only the
> > > directory placement of the files changed.
> > > 
> > > Signed-off-by: Pavel Roskin <proski@gnu.org>
> > 
> > I'm not going to support this code in any way.  I disclaim any
> > responsibility for this code.
> 
> Heh, that's fine with me, but as you did write this code, I do want to
> give you the proper credit.  I'll maintain it while it is in the staging
> tree.
> 
> You might want to poke John, as his version of this patch adds your name
> to the MAINTAINERS file in the Fedora kernels, something I don't think
> you want to have done :)

OK, I don't care as long as I don't get any bug reports or support
requests.

-- 
Regards,
Pavel Roskin
