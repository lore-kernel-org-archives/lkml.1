Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbYJNVIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbYJNVIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 17:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbYJNVH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 17:07:58 -0400
Received: from kroah.org ([198.145.64.141]:48558 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752738AbYJNVH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 17:07:58 -0400
Date: Tue, 14 Oct 2008 14:04:37 -0700
From: Greg KH <greg@kroah.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Adrian Bunk <bunk@kernel.org>, Am??rico Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.27 will be a longtime supported kernel
Message-ID: <20081014210437.GA17338@kroah.com>
References: <alpine.LFD.2.00.0810091651220.3210@nehalem.linux-foundation.org> <20081011210340.GA11198@cs181140183.pp.htv.fi> <20081013112701.GA12706@hack.voiplan.pt> <20081013123705.GF29938@cs181140183.pp.htv.fi> <20081014201054.GD22851@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014201054.GD22851@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 04:10:54PM -0400, Lennart Sorensen wrote:
> On Mon, Oct 13, 2008 at 03:37:05PM +0300, Adrian Bunk wrote:
> > If the question is why it isn't .26 or .28:
> > 
> > I'm checking whether my computer works fine with a kernel, and also 
> > very slightly what distributions might use a kernel, but in the end
> > it's pretty random.
> 
> So any distributions using .27 by the looks of it?  It looks like Debian
> is going with .26 for the 5.0 release, so if nothing else they will have
> to be maintaining that one for quite a while.  I suppose having someone
> maintain .27 makes sense in that case.

Fedora, Ubuntu, and openSUSE are going to be based on .27 from what I
can tell.

thanks,

greg k-h
