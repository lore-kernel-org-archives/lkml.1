Return-Path: <linux-kernel-owner+w=401wt.eu-S1757774AbYJQStd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbYJQStd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 14:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbYJQSss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 14:48:48 -0400
Received: from kroah.org ([198.145.64.141]:38535 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755042AbYJQSsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 14:48:47 -0400
Date: Fri, 17 Oct 2008 10:42:26 -0700
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081017174226.GF2221@kroah.com>
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016153053.GJ5834@nostromo.devel.redhat.com> <20081016154726.GA6331@kroah.com> <20081016171626.GB22554@cs181140183.pp.htv.fi> <20081017040239.GB28188@kroah.com> <20081017103138.1ca68d17@lxorguk.ukuu.org.uk> <48F8C000.8030003@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F8C000.8030003@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 09:40:32AM -0700, H. Peter Anvin wrote:
> Alan Cox wrote:
>>> So I proposed an alternative, YEAR.NUMBER.  The year is easy to keep
>> Which calendaring system ?
>
> Presumably the Gregorian one, rooted in the Common Era, but that's sort of 
> irrelevant.
>
> I think it's both visually cumbersome and has the problem that it is harder 
> to predict future releases.  The first problem can be dealt with by simply 
> subtracting 2000 from the year (Altera uses this scheme for their EDA 
> tools, and I didn't realize it for quite a while because it looked so 
> natural), but the second is still a problem.

What is the "problem" of predicting future releases?  What relies on the
actual number being "correct" some random time in the future?

thanks,

greg k-h
