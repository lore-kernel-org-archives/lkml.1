Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZGBKkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZGBKkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 06:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbZGBKkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 06:40:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51678 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750881AbZGBKkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 06:40:35 -0400
Date: Thu, 2 Jul 2009 11:42:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
Message-ID: <20090702114207.58724071@lxorguk.ukuu.org.uk>
In-Reply-To: <412e6f7f0907020218m1f4a9651l2c682a9905925bcd@mail.gmail.com>
References: <412e6f7f0907020036y76abbc7du99c7b695f725be4@mail.gmail.com>
	<20090702091309.GB6372@cr0.nay.redhat.com>
	<412e6f7f0907020218m1f4a9651l2c682a9905925bcd@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jul 2009 17:18:49 +0800
Changli Gao <xiaosuo@gmail.com> wrote:

> On Thu, Jul 2, 2009 at 5:13 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
> > On Thu, Jul 02, 2009 at 03:36:41PM +0800, Changli Gao wrote:
> >
> > Why? Why do you need this feature?
> >
> Are you familiar with splice() and tee()? They both use pipes as kernel buffers.

And are being used quite happily with the pipe() call. So what is the
problem ?
