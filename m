Return-Path: <linux-kernel-owner+w=401wt.eu-S1030858AbXEDPkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030858AbXEDPkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030780AbXEDPkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:40:12 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:40172 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030792AbXEDPkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:40:10 -0400
Date: Fri, 4 May 2007 11:40:09 -0400
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Strange soft lockup detected message (looks like spin_lock bug in pcnet32)
Message-ID: <20070504154009.GE8751@csclub.uwaterloo.ca>
References: <20070503203143.GA8753@csclub.uwaterloo.ca> <20070504141024.GB8753@csclub.uwaterloo.ca> <20070504143326.GD24769@slug> <20070504151934.GA8754@csclub.uwaterloo.ca> <20070504153438.GE24769@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070504153438.GE24769@slug>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 05:34:38PM +0200, Frederik Deweerdt wrote:
> For the "what" part, see Documentation/lockdep-design.txt. You'll enable
> it by with SPINLOCK_DEBUG, indeed.

Well I hope to see it hit the BUG again soon then to see what it has to
say.

--
Len Sorensen
