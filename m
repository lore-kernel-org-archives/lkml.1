Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbYBJHb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbYBJHb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbYBJHbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:31:48 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:40999 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282AbYBJHbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:31:47 -0500
Date: Sun, 10 Feb 2008 08:31:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
Message-ID: <20080210073153.GA9805@uranus.ravnborg.org>
References: <20080210071331.GC3851@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210071331.GC3851@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 08:13:31AM +0100, Ingo Molnar wrote:
> From: Jason Wessel <jason.wessel@windriver.com>
> 
> kgdb core code. Handles the protocol and the arch details.
> 
> [ mingo@elte.hu: heavily modified, simplified and cleaned up. ]

Hi Ingo.

I see that only a very few of my comments posted yesterday got addressed.
On purpose or did you miss them?

	Sam
