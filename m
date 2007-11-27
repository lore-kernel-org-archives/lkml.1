Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbXK0KPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbXK0KPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 05:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbXK0KPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 05:15:06 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59713 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753764AbXK0KPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 05:15:04 -0500
Date: Tue, 27 Nov 2007 02:14:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: bonding sysfs output
Message-Id: <20071127021418.8a05d225.akpm@linux-foundation.org>
In-Reply-To: <87prxwnh9g.fsf@tac.ki.iif.hu>
References: <87tznafjeu.fsf@szonett.ki.iif.hu>
	<20071125205150.4e49915f.akpm@linux-foundation.org>
	<87lk8lflzf.fsf@szonett.ki.iif.hu>
	<20071127004445.a046f791.akpm@linux-foundation.org>
	<87prxwnh9g.fsf@tac.ki.iif.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007 10:56:43 +0100 Ferenc Wagner <wferi@niif.hu> wrote:

> > - raise patches against the latest Linus tree
> > (ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots/)
> 
> I thought it was better to change to git.  Isn't it so?

Yes, git is a bit more uptodate than the snapshots.  But if that matters
you were very unlucky.

> SubmittingPatches has nothing to say about that...
> Can I find collected best practices somewhere?  Which tree, which
> branch, how/when to rebase, format-patch, etc...

gosh.  Documentation/Submit*,
http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt,
http://linux.yyz.us/patch-format.html, other places.  Probably people have
written books about it by now.  But don't sweat it - you're close enough ;)

