Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYLJUon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYLJUon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 15:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbYLJUof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 15:44:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43068 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbYLJUoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 15:44:34 -0500
Date: Wed, 10 Dec 2008 15:44:32 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu
Subject: Re: Better way to force a rebuild
In-Reply-To: <20081210203740.GA16674@uranus.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0812101541220.11805@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0812101443550.11805@gandalf.stny.rr.com> <20081210200242.GA15692@uranus.ravnborg.org> <20081210121048.6186eaf9.akpm@linux-foundation.org> <20081210203740.GA16674@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Dec 2008, Sam Ravnborg wrote:
> 
> I will fix the record_mcount stuff somehow.
> But not tonight. Busy with work-work.

Sam, Thanks!

No hurry, I was doing some clean ups when I came across that code, and 
said to myself "what an ugly hack!", and I wanted it fixed. The current 
hack works just fine, but it is an eye sore in the kernel.

I just wanted others to know that it needed to be cleaned up, and figured 
a post would help get it done.

Thanks,

-- Steve

