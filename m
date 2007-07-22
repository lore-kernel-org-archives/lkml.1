Return-Path: <linux-kernel-owner+w=401wt.eu-S933354AbXGVXvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354AbXGVXvs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761790AbXGVXvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:51:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758586AbXGVXvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:51:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alistair John Strachan <alistair@devzero.co.uk>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: Linus 2.6.23-rc1
In-Reply-To: Alistair John Strachan's message of  Monday, 23 July 2007 00:33:01 +0100 <200707230033.01357.alistair@devzero.co.uk>
X-Zippy-Says: Hello?  Enema Bondage?  I'm calling because I want to be happy, I guess..
Message-Id: <20070722235130.D9B094D0489@magilla.localdomain>
Date: Sun, 22 Jul 2007 16:51:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm fairly sure this is already known about on SPARC64 (see David Miller's 
> email ""build-id" changes break sparc64"), but I just thought I'd let people 
> know the warnings are also visible on x86_64:
> 
> "ld: warning: Cannot create .note.gnu.build-id section, --build-id ignored."

I don't have any such problem using an ld built from current binutils cvs.

> GNU assembler (GNU Binutils for Debian) 2.17.50.20070718

This ld build, whatever it is, is suspect.  
I have no idea what code is in there.


Thanks,
Roland
