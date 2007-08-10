Return-Path: <linux-kernel-owner+w=401wt.eu-S1763762AbXHJJ2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763762AbXHJJ2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 05:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932308AbXHJJ2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 05:28:11 -0400
Received: from twin.jikos.cz ([213.151.79.26]:52631 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765836AbXHJJ2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 05:28:09 -0400
Date: Fri, 10 Aug 2007 11:27:52 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: webmaster@dragonslave.de
cc: linux-kernel@vger.kernel.org, Stuart_Hayes@Dell.com,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: EHCI Regression in 2.6.23-rc2
In-Reply-To: <200708101045.57166.dex@dragonslave.de>
Message-ID: <Pine.LNX.4.64.0708101125120.3948@twin.jikos.cz>
References: <200708101045.57166.dex@dragonslave.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007, Daniel Exner wrote:

> Please CC me, as I'm currently not subscribed to this list, thx.

Please also don't forget to CC relevant people/lists when reporting bugs, 
thanks.

> After some serious hangs with 2.6.23-rc2 I did some bisects and this was the 
> result:
> 196705c9bbc03540429b0f7cf9ee35c2f928a534 is first bad commit
> commit 196705c9bbc03540429b0f7cf9ee35c2f928a534
> Author: Stuart_Hayes@Dell.com <Stuart_Hayes@Dell.com>
> Date:   Thu May 3 08:58:49 2007 -0700

I guess that the patch attached to bug 8535 in kernel.org bugzilla -- 
http://bugzilla.kernel.org/attachment.cgi?id=12228&action=view -- solves 
your issues, right?

Stuart, did you submit this fix for upstream already please?

-- 
Jiri Kosina
