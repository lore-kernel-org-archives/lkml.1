Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbYJHR5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbYJHR5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 13:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbYJHR5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 13:57:13 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:57699 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbYJHR5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 13:57:13 -0400
Date: Wed, 8 Oct 2008 18:57:10 +0100
From: Nick Warne <nick@ukfsn.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] Trivial patch to submitting-patches Documantation
Message-ID: <20081008185710.2754d60b@sauron.linicks.net>
In-Reply-To: <20081008103155.133f2692@tpl>
References: <20081008134401.68910c46@sauron.linicks.net>
	<20081008103155.133f2692@tpl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2008 10:31:55 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> On Wed, 8 Oct 2008 13:44:01 +0100
> Nick Warne <nick@ukfsn.org> wrote:
> 
> > Diff'ed against 2.6.26.5 stable tree.
> > 
> > Test-by tag is wrong.
> 
> I have a fix for this in my docs tree already.  Linus didn't pull it
> (not surprising, given that I just put it up last week), so I'll try
> again in the merge window.
> 
> Thanks,
> jon

Jon,

Did you see/catch my other trivial issue:

http://marc.info/?l=linux-kernel&m=122316762030204&w=2

In Documentation/cdrom/ide-cd, from line 148 is:

"Lacking anything else, you could use the
cdtester program in Documentation/cdrom/sbpcd".

This file is not present in stable 2.6.26.5 at least.


Thanks,

Nick
-- 
Free Software Foundation Associate Member 5508
