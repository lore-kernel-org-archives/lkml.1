Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbYEQB54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbYEQB54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 21:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbYEQB5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 21:57:48 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:39614 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751765AbYEQB5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 21:57:47 -0400
Date: Fri, 16 May 2008 21:57:06 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT pull] x86 fixes for 2.6.26
Message-ID: <20080517015705.GA20375@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>
References: <alpine.LFD.1.10.0805170037180.3255@apollo.tec.linutronix.de> <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 03:47:53PM -0700, Linus Torvalds wrote:
> Do nice topic branches, where each branch has a reason for existing. The 
> "x86-fixes-for-linus" branch has x86 fixes. 
> 
> This happens almost every time somebody starts using git properly: at that 
> point the rebasing no longer hides bad habits.

Why do you consider rebasing topic branches a bad thing?  It does help
keep the history much cleaner, and it means that I can test to make
sure the topic branch works well with the latest head of the
development branch.

Is there a write up of what you consider the "proper" git workflow?

   	   	       	    		     	      - Ted
