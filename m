Return-Path: <linux-kernel-owner+w=401wt.eu-S1762046AbXERLTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762046AbXERLTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 07:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbXERLTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 07:19:13 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46219 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbXERLTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 07:19:13 -0400
Date: Fri, 18 May 2007 05:19:11 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Asynchronous scsi scanning
Message-ID: <20070518111911.GP10562@parisc-linux.org>
References: <a781481a0705171013j7ddc48edxfb4bdba515a3f53c@mail.gmail.com> <20070517172023.GL10562@parisc-linux.org> <a781481a0705171041y3c3b7fe1m2aa6a8805807942c@mail.gmail.com> <20070517182414.GA12170@infradead.org> <a781481a0705171147s1ef5c205y8873d0bfa201f928@mail.gmail.com> <20070517185115.GA13207@infradead.org> <a781481a0705171204o5b25fafdm36d5970acf9119cd@mail.gmail.com> <20070517193953.GM10562@parisc-linux.org> <20070517194326.GC30571@kvack.org> <a781481a0705172041q6bc87f04v7a60eb62ad26d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0705172041q6bc87f04v7a60eb62ad26d6@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 09:11:58AM +0530, Satyam Sharma wrote:
> It's also somewhat a matter of *taste* (and hence subjective), if you
> _still_ don't get it, Matthew, then there's no point continuing this thread
> and trying to convince you ad infinitum.

Right.  It's a matter of taste.  What makes you think you have taste?

I don't think that the module solution is perfect.  But abusing the
module parameters is a worse idea.  sysfs just isn't a good fit for this,
according to my taste.

