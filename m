Return-Path: <linux-kernel-owner+w=401wt.eu-S1423034AbXBHADb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423034AbXBHADb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423045AbXBHADb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:03:31 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:32837 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423034AbXBHADa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:03:30 -0500
Date: Thu, 8 Feb 2007 01:03:23 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Oleg Verych <olecom@flower.upol.cz>, Alexey Dobriyan <adobriyan@gmail.com>,
       sam@ravnborg.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kai Germaschewski <kai@germaschewski.name>
Subject: Re: [patch, fix build regression] kbuild: Kbuild.include avoid using
 spaces in call arguments
In-Reply-To: <Pine.LNX.4.64.0702071546420.8424@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702080058420.14457@scrub.home>
References: <20070207165204.GA5537@martell.zuzino.mipt.ru>
 <Pine.LNX.4.64.0702071846180.14457@scrub.home> <20070207220435.GC22699@flower.upol.cz>
 <Pine.LNX.4.64.0702080029030.14457@scrub.home>
 <Pine.LNX.4.64.0702071546420.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 7 Feb 2007, Linus Torvalds wrote:

> So I end up in a situation where I just basically will apply the patches 
> just becauseif I don't, nothing ever happens. The good news is that _once_ 
> I apply them, people will usually notice problems and send in fixes fairly 
> quickly. But this particular email was NOT useful, for example.  "needs 
> more changes" is the epitome of a "not useful" comment.

The patch was already in -mm and being worked on...

> In the meantime, I've applied the fixup patch. And more specific problem 
> reports or patches are welcome.

_Please_ revert completely and wait for Andrew to send it via -mm, when 
it's ready.

bye, Roman
