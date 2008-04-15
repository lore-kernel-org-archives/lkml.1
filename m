Return-Path: <linux-kernel-owner+w=401wt.eu-S1764206AbYDODP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764206AbYDODP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 23:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761823AbYDODPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 23:15:11 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35959 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761586AbYDODPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 23:15:10 -0400
Date: Mon, 14 Apr 2008 23:14:37 -0400
Message-Id: <200804150314.m3F3Ebg5016584@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Bob Copeland <me@bobcopeland.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3 
In-reply-to: Your message of "Sat, 12 Apr 2008 23:33:44 EDT."
             <20080413033344.GA27494@hash.localnet> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080413033344.GA27494@hash.localnet>, Bob Copeland writes:
> On Sat, Apr 12, 2008 at 05:03:04PM -0700, Andrew Morton wrote:
[...]

> > Who did the reverse-engineering, and how was it done?
> > Please make us confident that we won't get our butts sued off or something.
> 
> I'm not sure there's a company to sue anymore.

<IANAL>

Bob, you have to be careful there; an argument like "there may not be a
company to sue" may not hold.  IP rights, patents and their filings, and
more, can be sold, traded, transferred, inherited, etc. -- even if the
original company is no longer in business.  I don't know the history of
ReplayTV or how it went out of business, but it might be worth a check to
see if there's anyone who can still claim any rights over any part of OMFS
(e.g., chapter 11 creditors who may feel they didn't get fully compensated).
The irony is that as long as omfs gets little attention, no one is likely to
sue; but once and if it gets into mainline and lots of Big Name Linux
distros start carrying it, *then* someone may come out from the shadows to
sue.

</IANAL>

Erez.
