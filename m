Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbXD0CII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbXD0CII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 22:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbXD0CIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 22:08:07 -0400
Received: from mx33.mail.ru ([194.67.23.194]:5444 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407AbXD0CIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 22:08:06 -0400
Date: Fri, 27 Apr 2007 06:05:02 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ANNOUNCE] battery2 git repository
Message-ID: <20070427020502.GA18645@zarina>
Reply-To: cbou@mail.ru
References: <20070426232902.GA10423@zarina> <20070427000928.GA5303@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070427000928.GA5303@suse.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 05:09:28PM -0700, Greg KH wrote:
> On Fri, Apr 27, 2007 at 03:29:02AM +0400, Anton Vorontsov wrote:
> > 
> > To not confuse with David own battery-2.6 repository, it's called
> > battery2-2.6, and can be found here:
> 
> So, I'm still not quite understanding this, is David giving up on his
> code now that you have pulled his changes into your tree?  Or is there
> some reason there are still two competing versions here?

[ Of course David will answer for himself better. Below is what I'm
  seeing. ]

David said he intend to port his OLPC and Apple PMU work to battery2
class implementation (and I volunteered to assist, i.e. port them
myself ;-). So, when these two drivers will be ported, then there
will no reasons for battery-2.6 existence anymore.

As for the competition... No competition took place at all, there was
two parallel works, each for two *independent* projects (OLPC and
handhelds.org). battery2 should be suitable for both.


David?

> thanks,
> 
> greg k-h

Sincerely,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
