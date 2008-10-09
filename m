Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbYJISI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbYJISI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 14:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbYJISIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 14:08:19 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:18017 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbYJISIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 14:08:18 -0400
Date: Thu, 9 Oct 2008 11:07:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Nick Warne <nick@ukfsn.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH] Trivial patch to submitting-patches Documantation
Message-Id: <20081009110757.d937c872.randy.dunlap@oracle.com>
In-Reply-To: <20081008185710.2754d60b@sauron.linicks.net>
References: <20081008134401.68910c46@sauron.linicks.net>
	<20081008103155.133f2692@tpl>
	<20081008185710.2754d60b@sauron.linicks.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2008 18:57:10 +0100 Nick Warne wrote:

> On Wed, 8 Oct 2008 10:31:55 -0600
> Jonathan Corbet <corbet@lwn.net> wrote:
> 
> > On Wed, 8 Oct 2008 13:44:01 +0100
> > Nick Warne <nick@ukfsn.org> wrote:
> > 
> > > Diff'ed against 2.6.26.5 stable tree.
> > > 
> > > Test-by tag is wrong.
> > 
> > I have a fix for this in my docs tree already.  Linus didn't pull it
> > (not surprising, given that I just put it up last week), so I'll try
> > again in the merge window.
> > 
> > Thanks,
> > jon
> 
> Jon,
> 
> Did you see/catch my other trivial issue:
> 
> http://marc.info/?l=linux-kernel&m=122316762030204&w=2
> 
> In Documentation/cdrom/ide-cd, from line 148 is:
> 
> "Lacking anything else, you could use the
> cdtester program in Documentation/cdrom/sbpcd".
> 
> This file is not present in stable 2.6.26.5 at least.

Nick,
Thanks for the report.  I just sent a patch for this as a reply
to your original posting.

---
~Randy
