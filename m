Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbYFJUMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbYFJUMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbYFJUMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:12:25 -0400
Received: from sous-sol.org ([216.99.217.87]:55663 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbYFJUMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:12:24 -0400
Date: Tue, 10 Jun 2008 13:12:23 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.25.6
Message-ID: <20080610201218.GM4018@sequoia.sous-sol.org>
References: <20080609194924.GL30402@sequoia.sous-sol.org> <20080610145325.GC23351@khazad-dum.debian.net> <20080610191726.GB4218@tatooine.rebelbase.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610191726.GB4218@tatooine.rebelbase.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* markus reichelt (ml@mareichelt.de) wrote:
> * Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> > On Mon, 09 Jun 2008, Chris Wright wrote:
> > > We (the -stable team) are announcing the release of the 2.6.25.6
> > > kernel.
> > > 
> > > It contains a number of assorted bugfixes all over the tree.  Users are
> > > encouraged to update.
> > 
> > It also contains at least one security bugfix, as some were quick
> > to point out in not-so-kind words:
> > 
> > http://lwn.net/Articles/285438/
> 
> I agree that security bugfixes should be pointed out more clearly.

I don't think anybody is disagreeing with that.  It's not always
obvious to bug submitters or fixers what the security implications are.
While Brad has a good point, esp. w.r.t. the specific cpufreq bug he
picked out having security implications, it is not true that we are
actively hiding security bugs.  Had I realized there was a security
issue, I would highlight it in the announce message.  In fact, that's
our standard procedure for -stable.

thanks,
-chris
