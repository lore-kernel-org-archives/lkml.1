Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbYETIBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbYETIBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbYETIBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:01:15 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:25730 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753433AbYETIBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:01:14 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYEACwhMkhR8DYR/2dsb2JhbACBVawf
Date: Tue, 20 May 2008 10:01:10 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/57] watchdog: Giant scrub
Message-ID: <20080520080110.GA2724@infomag.infomag.iguana.be>
References: <20080519124659.31722.51847.stgit@core> <20080519112148.4d078ad4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519112148.4d078ad4.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

> eek.
> 
> This comes at a time when git-watchdog has
> 
> and hasn't had a commit in six weeks, missed the merge window and the
> most recent commit is titled "[WATCHDOG] rc32434_wdt: critical
> bugfixes".
> 
> Wim, come back!
> 
> (Happily there appears to be little overlap between the two diffstats there)

Sorry guys, I had to do electricity, ... for the new house. I have to finish
still one thing tonight and then things should be normal again for a few weeks.
I indeed have some backlog, but Alan's patches seems rather straight forward.
I'll merge them in the linux-watchdog-mm tree as soon as possible (but i'll first
sent some watchdog patches over to linus because I seemed to have missed allready
2 rc releases :-( ).

Greetings,
Wim.

