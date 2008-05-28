Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbYE1VU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbYE1VU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYE1VUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:20:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47589 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbYE1VUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:20:10 -0400
Date: Wed, 28 May 2008 14:10:07 -0700
From: Greg KH <greg@kroah.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: jidong xiao <jidong.xiao@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove Documentation/usb/uhci.txt
Message-ID: <20080528211007.GB18425@kroah.com>
References: <20080519220024.GX17716@cs181133002.pp.htv.fi> <4104961b0805272338o5fe40727i26b74f195ef1af89@mail.gmail.com> <417e6455e9cc5c73d1ddeb00592b77b3@felipebalbi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <417e6455e9cc5c73d1ddeb00592b77b3@felipebalbi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 08:34:05AM -0500, Felipe Balbi wrote:
> 
> 
> On Wed, 28 May 2008 14:38:42 +0800, "jidong xiao" <jidong.xiao@gmail.com>
> wrote:
> > On Tue, May 20, 2008 at 6:00 AM, Adrian Bunk <bunk@kernel.org> wrote:
> >> The driver was removed before kernel 2.6.0
> >>
> >> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >>
> >> ---
> >>
> > 
> > But I think this document is still very useful and informative
> > especially to those who are not quite familiar with UHCI HCDs. It is
> > not necessary to remove this one at the moment.
> 
> True. I vote for keeping the doc :-)

Sorry, it's old and out dated.  If you wish to refresh it and add it
back, I'll gladly accept that patch.

thanks,

greg k-h
