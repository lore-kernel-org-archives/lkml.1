Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbZJZRqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbZJZRqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbZJZRqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:46:15 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41103 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbZJZRqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:46:13 -0400
Date: Mon, 26 Oct 2009 13:43:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: david@lang.hm
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 1/4] strip: move driver to staging
Message-ID: <20091026174317.GG2792@tuxdriver.com>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com> <20091023161006.GA1580@ucw.cz> <20091026165518.GE2792@tuxdriver.com> <alpine.DEB.2.00.0910261013430.11504@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910261013430.11504@asgard.lang.hm>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 10:18:20AM -0700, david@lang.hm wrote:
> On Mon, 26 Oct 2009, John W. Linville wrote:

>> "ongoing maintenance for no clear benefit" -- that is what is wrong
>> with it.
>
> supporting existing hardware is no longer a 'clear benifit'?

Do you own or have access to such hardware?  If the hardware is
obsolete, unused, and mostly non-existant then what is the benefit
to maintaining a driver that is rotting?

> is this driver broken (as in not working)?

I have no idea.  I suspect that you don't know either.

> other than the fact that you don't think many people have this hardware,  
> is there anything wrong with this driver?

It sits there, bloating the target area for API maintenance and
providing a likely broken example of how to write Linux drivers.

> if this driver hasn't been changed other than for blanket API changes, 
> how is it causing significant problems?

It is a distraction for no clear (or even murky) benefit, one more
thing to keep compiling.

> if someone were to claim 'maintainership' and then do nothing other than  
> complain if someone else were to change an API but not fix this in the  
> process, how would this be different than the current situation?

Not much different, possibly worse if they created a bigger
distraction.  But if they actually had the hardware we might at least
be confident that the effort was in some way worthwhile...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
