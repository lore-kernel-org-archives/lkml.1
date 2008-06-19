Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbYFSLGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbYFSLGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 07:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758056AbYFSLGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 07:06:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37285 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916AbYFSLGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 07:06:32 -0400
Date: Thu, 19 Jun 2008 04:01:45 -0700
From: Greg KH <greg@kroah.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Hellwig <hch@infradead.org>,
       Gaudenz Steinlin <gaudenz@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       486798@bugs.debian.org, josejx@gentoo.org
Subject: Re: [PATCH] restore export of handle_mm_fault for Mac on Linux
Message-ID: <20080619110145.GA27196@kroah.com>
References: <20080618101402.GF15718@soziologie.ch> <20080618181856.3474859d@lxorguk.ukuu.org.uk> <20080619095805.GA28907@soziologie.ch> <20080619103837.GA16331@infradead.org> <84144f020806190346t6c27fa02w77de08a14bd5cb89@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020806190346t6c27fa02w77de08a14bd5cb89@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 01:46:57PM +0300, Pekka Enberg wrote:
> On Thu, Jun 19, 2008 at 11:58:05AM +0200, Gaudenz Steinlin wrote:
> >> There is an effort underway to bring the MOL kernel modules into
> >> a mergeable form. But it's not there yet. Joseph Jezak, the MOl main
> >> developer nowdays is working on it. So MOL no longer want's to hide out
> >> of tree. It just needs some more time.
> 
> On Thu, Jun 19, 2008 at 1:38 PM, Christoph Hellwig <hch@infradead.org> wrote:
> > It would be useful if you could send some status-updates to lkml and
> > the kvm list.
> 
> And why not submit MOL to the new linux-staging tree?

That sounds good to me, send them over when you have something that
builds and looks semi-sane :)

thanks,

greg k-h
