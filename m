Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbYGZJTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbYGZJTY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 05:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbYGZJTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 05:19:05 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:51653 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbYGZJTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 05:19:04 -0400
Date: Fri, 25 Jul 2008 20:52:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       dbrownell@users.sourceforge.net
Subject: Re: [PATCH] kernel-doc: handle/strip __init
Message-ID: <20080725185222.GA22918@uranus.ravnborg.org>
References: <20080619160329.1a4fe917.randy.dunlap@oracle.com> <20080627210521.GC29245@uranus.ravnborg.org> <20080722133605.34a399a8.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722133605.34a399a8.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 01:36:05PM -0700, Randy Dunlap wrote:
> On Fri, 27 Jun 2008 23:05:21 +0200 Sam Ravnborg wrote:
> 
> > On Thu, Jun 19, 2008 at 04:03:29PM -0700, Randy Dunlap wrote:
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > cc: David Brownell <dbrownell@users.sourceforge.net>
> > > 
> > > Handle __init in functions with kernel-doc notation by stripping the
> > > __init away from the output doc.  This is already being done for
> > > "__devinit".  This patch fixes these kernel-doc error/aborts:
> > 
> > Applied
> 
> Hi Sam,
> 
> This patch is now needed so that "make *docs" does not fail.
> 
> Will you have Linus pull your tree soon or shall I send it separately?

I just returned from vacation and to a restored Internet connection today.
I will prepare a pull request tonight.

	Sam
