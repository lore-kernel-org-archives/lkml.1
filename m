Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbZIOWGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbZIOWGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 18:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbZIOWGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 18:06:09 -0400
Received: from fifo99.com ([67.223.236.141]:59643 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbZIOWGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 18:06:07 -0400
Subject: Re: [PATCH 06/20] mem_class: use minor as index instead of
 searching  the array
From: Daniel Walker <dwalker@fifo99.com>
To: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090915213235.GA6968@suse.de>
References: <20090915181247.GA32167@kroah.com>
	 <1253041976-1111-6-git-send-email-gregkh@suse.de>
	 <1253043763.11643.358.camel@desktop>
	 <ac3eb2510909151246r59decb10pfb68fd5c0cb9a63a@mail.gmail.com>
	 <1253045229.11643.398.camel@desktop> <20090915202445.GC3411@suse.de>
	 <1253049491.11643.490.camel@desktop> <20090915212019.GA6744@suse.de>
	 <1253050006.11643.492.camel@desktop>  <20090915213235.GA6968@suse.de>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 15:06:56 -0700
Message-Id: <1253052416.11643.523.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 14:32 -0700, Greg KH wrote:
> On Tue, Sep 15, 2009 at 02:26:46PM -0700, Daniel Walker wrote:
> > On Tue, 2009-09-15 at 14:20 -0700, Greg KH wrote:
> > 
> > > I'll gladly do that, it's trival for me to do so.
> > > 
> > 
> > What about the other side ? The people who are sending the clean ups,
> > there time is valuable too..
> 
> Don't you mean "their"?  (hey, I can be nit-picky too...)

Yeah, I'll send you a clean up email for that tomorrow ;)

> And yes, but the engineering model of the kernel development cycle is
> that engineer hours are wasted and thrown away all the time.  They are
> surplus, sorry.  That's how life works here.

It's like we're driving the SUVs that run on engineering hours ? Just
imagine the electrical power savings you would get if you had 1000 less
emails send to you daily .. But seriously, why waste people time if it
can be prevented ..

Less checkpatch errors, less wasted time, better for the environment..

> > I hope you don't ignore these errors very often ..
> 
> More often then you want to know, I have real issues to deal with :)

I'm sure I have no idea..

Daniel

