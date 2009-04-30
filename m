Return-Path: <linux-kernel-owner+w=401wt.eu-S1763881AbZD3Wlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763881AbZD3Wlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763458AbZD3Wln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:41:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760204AbZD3Wlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:41:42 -0400
Date: Thu, 30 Apr 2009 15:32:12 -0700
From: Greg KH <gregkh@suse.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/88] 2.6.28.10-stable review
Message-ID: <20090430223212.GA16341@suse.de>
References: <20090430170122.GA16015@kroah.com> <20090430214450.GC7174@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430214450.GC7174@khazad-dum.debian.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 06:44:50PM -0300, Henrique de Moraes Holschuh wrote:
> On Thu, 30 Apr 2009, Greg KH wrote:
> > This is the start of the stable review cycle for the 2.6.28.10 release.
> > 
> > NOTE!  This is going to be the last release in the 2.6.28-stable series!
> 
> Could you be convinced to keep 2.6.28-stable around for a little longer?

Not really.

> 2.6.29 is still much too young, as one can see from the size of 2.6.29.2,

That is mostly because people are learning to submit more patches to the
-stable queue, not because of any implicit problems with the 2.6.29
kernel series that I have seen.

> and the fact that the queue for 2.6.29 isn't even empty yet and there are
> already more patches waiting to get queued...

Yes there are, I will work on that next.  But I don't see anything
"serious" in there that should be in the .28 kernel, do you?

Traditionally we've dropped the last -stable after the .2 release of the
new series, why would we change that now?  We only have so much time to
do this kind of work, and maintaining 3 -stable trees is a major pain,
trust me...

However, if you wish to take over 2.6.28 and maintain it after this
release, I have no objection, just let me know.

thanks,

greg k-h
