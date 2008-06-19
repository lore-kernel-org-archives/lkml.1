Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbYFSKjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbYFSKjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 06:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757320AbYFSKin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 06:38:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45955 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592AbYFSKij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 06:38:39 -0400
Date: Thu, 19 Jun 2008 06:38:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Gaudenz Steinlin <gaudenz@debian.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       486798@bugs.debian.org, josejx@gentoo.org
Subject: Re: [PATCH] restore export of handle_mm_fault for Mac on Linux
Message-ID: <20080619103837.GA16331@infradead.org>
References: <20080618101402.GF15718@soziologie.ch> <20080618181856.3474859d@lxorguk.ukuu.org.uk> <20080619095805.GA28907@soziologie.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619095805.GA28907@soziologie.ch>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 11:58:05AM +0200, Gaudenz Steinlin wrote:
> There is an effort underway to bring the MOL kernel modules into
> a mergeable form. But it's not there yet. Joseph Jezak, the MOl main
> developer nowdays is working on it. So MOL no longer want's to hide out
> of tree. It just needs some more time.

It would be useful if you could send some status-updates to lkml and
the kvm list.

> 
> What I'm asking for is to get the export back, that as far as I can see
> was removed accidentialy and that was there before specially for MOL. 

It was removed intentionally.

