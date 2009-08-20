Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbZHTVbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbZHTVbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbZHTVbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:31:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755402AbZHTVbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:31:37 -0400
Date: Thu, 20 Aug 2009 14:30:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       peterz@infradead.org, torvalds@linux-foundation.org, tytso@mit.edu,
       arjan@infradead.org, greg@kroah.com, mcgrof@gmail.com,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org, sam@ravnborg.org,
       corbet@lwn.net, sourcejedi.lkml@googlemail.com, andi@firstfloor.org
Subject: Re: [PATCH 00/14] kconfig: streamline distro configs for testers
Message-Id: <20090820143025.7134930f.akpm@linux-foundation.org>
In-Reply-To: <20090819025634.987354707@goodmis.org>
References: <20090819025634.987354707@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009 22:56:34 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Here's my rebase of the prior push of streamline-config.pl.

ow, you made me look at perl code.

> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: kconfig

Sam's been quiet lately.  I suggest that you add this to linux-next
now so people get a chance to poke at it.
