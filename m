Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYGZAlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYGZAlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 20:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbYGZAla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 20:41:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827AbYGZAl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 20:41:29 -0400
Date: Fri, 25 Jul 2008 17:38:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Please pull from powerpc.git merge branch
In-Reply-To: <1217027473.11188.120.camel@pasglop>
Message-ID: <alpine.LFD.1.10.0807251734030.4188@nehalem.linux-foundation.org>
References: <1217027473.11188.120.camel@pasglop>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Jul 2008, Benjamin Herrenschmidt wrote:
> 
> Please pull from:
> ﻿
> ﻿git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

What odd character do you have there before the 'git://' and why?

It cuts-and-pastes into some whitespace that isn't space, and that the 
shell thus makes part of that word when parsing. It seems to be U+FEFF, 
which is "zero-width non-break space", but what the heck is the point of 
that kind of garbage in email?

Is this some new way for Evolution to screw up?

			Linus
