Return-Path: <linux-kernel-owner+w=401wt.eu-S1752692AbZHSOfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbZHSOfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 10:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbZHSOfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 10:35:51 -0400
Received: from kroah.org ([198.145.64.141]:49056 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbZHSOfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 10:35:51 -0400
Date: Wed, 19 Aug 2009 07:29:32 -0700
From: Greg KH <greg@kroah.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 00/14] kconfig: streamline distro configs for testers
Message-ID: <20090819142932.GA31393@kroah.com>
References: <20090819025634.987354707@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090819025634.987354707@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 10:56:34PM -0400, Steven Rostedt wrote:
> Here's my rebase of the prior push of streamline-config.pl.

Very nice, thanks for pushing this forward, it's much needed.

greg k-h
