Return-Path: <linux-kernel-owner+w=401wt.eu-S1761288AbXGUE3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761288AbXGUE3u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 00:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbXGUE3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 00:29:43 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:42658 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750993AbXGUE3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 00:29:42 -0400
Message-ID: <384992173.15244@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 21 Jul 2007 12:29:40 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/8] compacting file_ra_state
Message-ID: <20070721042939.GA28875@mail.ustc.edu.cn>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
References: <20070721035733.951838089@mail.ustc.edu.cn> <20070721035850.977231489@mail.ustc.edu.cn> <384990797.09024@ustc.edu.cn> <alpine.LFD.0.999.0707202126250.27249@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707202126250.27249@woody.linux-foundation.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 09:27:01PM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 21 Jul 2007, Fengguang Wu wrote:
> >
> > Sorry, forgot to prefix the patch titles with [readahead].
> > Should I repost?
> 
> Not for me, but on the other hand, I'd prefer for this to be in -mm a bit, 
> even if it does mean missing the merge window this time around. 

OK. Let me repost it...

