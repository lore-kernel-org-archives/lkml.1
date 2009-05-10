Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbZEJP5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbZEJP5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 11:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbZEJP5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 11:57:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:59664 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbZEJP5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 11:57:37 -0400
Date: Sun, 10 May 2009 08:59:57 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090510085957.1c15b208@infradead.org>
In-Reply-To: <20090510152005.GA9461@suse.de>
References: <20090509143742.GA27663@kroah.com>
	<b637ec0b0905090810t188e39e3w92d9f4eff04011f1@mail.gmail.com>
	<20090509150853.GA32394@suse.de>
	<20090509082233.32cbb8e4@infradead.org>
	<20090509161923.GA942@suse.de>
	<20090509223454.4642753d.akpm@linux-foundation.org>
	<20090510152005.GA9461@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 May 2009 08:20:05 -0700
Greg KH <gregkh@suse.de> wrote:

> On Sat, May 09, 2009 at 10:34:54PM -0700, Andrew Morton wrote:
> > On Sat, 9 May 2009 09:19:23 -0700 Greg KH <gregkh@suse.de> wrote:
> > 
> > >  We need to be able to support large number of partitions at boot
> > > time. 
> > 
> > I suspect that the intersection between (systems which need to shave
> > boot time to the minimum) and (systems which have lots of
> > partitions) is quite small?
> 
> No, not at all, lots of desktops have one or two disks with 15+
> partitions.  Those users want fast boot times as well.

if partitions > 15 don't have stable numbers surely we could fix
that....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
