Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbXJCT0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbXJCT0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 15:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbXJCT0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 15:26:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38273 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751879AbXJCTZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 15:25:59 -0400
Date: Wed, 3 Oct 2007 12:25:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
In-Reply-To: <4703E888.9010803@garzik.org>
Message-ID: <alpine.LFD.0.999.0710031223200.3579@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
 <4703E888.9010803@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Oct 2007, Jeff Garzik wrote:
> 
> I'm a bit confused...  you typed 2.6.24-rc4; I'm guessing you meant
> 2.6.24-rc1, but did you mean

No, I just meant "2.6.24 merge window", so:

> 	"x86 merge as soon as 2.6.23 is released" (merge window opens)

is the correct interpretation.

It will probably be a day or two after the 2.6.23 release, just because I 
like evertybody to look at the release tree after a release, but it would 
be the first set of changes that get merged (assuming there are no stupid 
brown-paper-bag issues that would get priority).

		Linus
