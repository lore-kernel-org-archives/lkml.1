Return-Path: <linux-kernel-owner+w=401wt.eu-S1761966AbYEXU52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761966AbYEXU52 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 16:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761126AbYEXU5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 16:57:21 -0400
Received: from gw.goop.org ([64.81.55.164]:60655 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760965AbYEXU5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 16:57:20 -0400
Message-ID: <48388112.6030003@goop.org>
Date: Sat, 24 May 2008 21:56:50 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [RFC PATCH] kconfig: introduce KCONFIG_* symbols for .c files
References: <20080524192540.GA28067@uranus.ravnborg.org> <20080524125316.4b969936.akpm@linux-foundation.org> <48387736.9050004@goop.org> <20080524204610.GB3136@uranus.ravnborg.org>
In-Reply-To: <20080524204610.GB3136@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> When we have one configuration for the kernel and not as today
> where we have one configuration for each architecture (with a lot
> of shared files) then it is already taken care of by my (updated) patch.

Yep.  But is a unified config something that someone is actively working 
on, or a distant pipe dream?

    J
