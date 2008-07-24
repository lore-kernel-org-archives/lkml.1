Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbYGXXKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbYGXXKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 19:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbYGXXKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 19:10:23 -0400
Received: from iabervon.org ([66.92.72.58]:47736 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747AbYGXXKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 19:10:23 -0400
Date: Thu, 24 Jul 2008 19:10:20 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Jack Howarth <howarth@bromo.msbb.uc.edu>
cc: linux-kernel@vger.kernel.org
Subject: Re: merging branches remotely with git?
In-Reply-To: <20080724224801.GA32241@bromo.msbb.uc.edu>
Message-ID: <alpine.LNX.1.00.0807241904210.19665@iabervon.org>
References: <20080724173030.GA7609@bromo.msbb.uc.edu> <alpine.LNX.1.00.0807241453470.19665@iabervon.org> <20080724224801.GA32241@bromo.msbb.uc.edu>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008, Jack Howarth wrote:

> Daniel,
>    If I execute...
> 
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/my-wireless-testing.git
> cd my-wireless-testing
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 
> I get the error...
> 
> You asked me to pull without telling me which branch you
> want to merge with, and 'branch.master.merge' in
> your configuration file does not tell me either.

Ah, sorry. Add " master" to the end of that.

> ps Which git represents the git patches (like 2.6.26-git11) which are
> placed as patches on the www.kernel.org web page under the section
> The latest snapshot for the stable Linux kernel tree is:.

Those come from the current state of the master branch of the 
...torvalds/linux-2.6 repository as of when they're made, but I don't know 
how to figure out what -git11 is, as opposed to -git10 or any of the 
commits done in between.

	-Daniel
*This .sig left intentionally blank*
