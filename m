Return-Path: <linux-kernel-owner+w=401wt.eu-S1761414AbYBCKoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761414AbYBCKoU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 05:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbYBCKoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 05:44:10 -0500
Received: from zakalwe.fi ([80.83.5.154]:58732 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbYBCKoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 05:44:09 -0500
Date: Sun, 3 Feb 2008 12:44:07 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Greg KH <greg@kroah.com>
Cc: Daniel Hazelton <dhazelton@enter.net>, linux-kernel@vger.kernel.org,
       mpm@selenic.com, ak@suse.de, m-ikeda@ds.jp.nec.com, zhongyu@18mail.cn,
       minchan.kim@gmail.com
Subject: Re: [PATCH] Improve Documentation/stable_api_nonsense.txt v2
Message-ID: <20080203104407.GH12172@zakalwe.fi>
References: <20080202144457.653482BC98@zakalwe.fi> <20080203002249.GB3453@kroah.com> <200802021952.37848.dhazelton@enter.net> <20080203050310.GA23824@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080203050310.GA23824@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 09:03:10PM -0800, Greg KH wrote:
> On Sat, Feb 02, 2008 at 07:52:37PM -0500, Daniel Hazelton wrote:
> > Actually, Greg, a hell of a lot of people that don't track linux kernel 
> > development do think that way. And there are always going to be people that 
> > think that way.
> 
> So why would to more sentances trying to say "see, we really do know
> what we are doing, we aren't idiots" make things any better to these
> people?  (hint, it wouldn't...)

I have similar experience as Daniel..

It seems we need to say that because I have heard some people complain
about the lack of stable interfaces. In fact, I wrote the original patch
just after one person blamed Linux for not having stable interfaces,
and that Linux people just change those APIs to be mean for third 
parties (which is obviously false).

> The whole article explains why apis are change for very good reasons
> (evolution of hardware, security, we now know better, etc.)  That's the
> whole point of the document...

... And the new paragraph supports that goal by assuring others that 
we don't do unnecessary changes.

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
