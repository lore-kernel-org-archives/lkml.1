Return-Path: <linux-kernel-owner+w=401wt.eu-S1760847AbXEaSLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760847AbXEaSLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757796AbXEaSLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:11:08 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757244AbXEaSLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:11:05 -0400
Date: Thu, 31 May 2007 11:10:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ken Chen" <kenchen@google.com>
Cc: walt <wa1ter@myrealbox.com>, linux-kernel@vger.kernel.org
Subject: Re: + loop-preallocate-eight-loop-devices.patch added to -mm tree
Message-Id: <20070531111052.534573b8.akpm@linux-foundation.org>
In-Reply-To: <b040c32a0705310951t7d9acdf5n34815bc5fc156e26@mail.gmail.com>
References: <200705212200.l4LM0tYK021050@shell0.pdx.osdl.net>
	<20070522001851.GE4095@ftp.linux.org.uk>
	<b040c32a0705211830h127dfd8dk8930de6655d37d90@mail.gmail.com>
	<20070522014822.GF4095@ftp.linux.org.uk>
	<b040c32a0705211914w3843bd46o542476be97e0b6cf@mail.gmail.com>
	<b040c32a0705211940xe7cdf1cnb2c882edacc17a27@mail.gmail.com>
	<f3mro0$u8p$1@sea.gmane.org>
	<b040c32a0705310951t7d9acdf5n34815bc5fc156e26@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 09:51:36 -0700
"Ken Chen" <kenchen@google.com> wrote:

> On 5/31/07, walt <wa1ter@myrealbox.com> wrote:
> > Ken Chen wrote:
> > > On 5/21/07, Ken Chen <kenchen@google.com> wrote:
> > ...
> > > tested, like this?
> >
> > Ken, your patch below works for me.  Are you going to send this
> > on to Linus?
> 
> I think akpm will route this to Linus.  andrew?

I have a note here that it needs additional work.  This discussion:

http://lkml.org/lkml/2007/5/21/602

seemed to peter out and go nowhere?
