Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbYKWRa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbYKWRa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 12:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbYKWRaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 12:30:18 -0500
Received: from qb-out-0506.google.com ([72.14.204.238]:8661 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbYKWRaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 12:30:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kY1nB5ElGmxK+ZDrIUH2YAlW7vlC3q1bC5JzA9mJwiP9NvaxQP+mua8hVwtQrnzsYe
         3Ks2vrGq9upcYwv7IeRgclCv/x+wpRk4TlS8qpm2aiS66pAvehNpwBGGNaK518W8r6Yg
         foMzrs/jnYwFCY5Pznkddo2n01yXbke1k4heY=
Date: Sun, 23 Nov 2008 20:30:15 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86: introduce ENTRY(KPROBE_ENTRY)_X86  assembly
	helpers to catch unbalanced declaration v3
Message-ID: <20081123173015.GE12710@localhost>
References: <20081123172139.GC12710@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123172139.GC12710@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sun, Nov 23, 2008 at 08:21:39PM +0300]
| Impact: improvements
| 
| It's usefull to catch unbalanced or messed or mixed declarations of ENTRY and
| KPROBES. These macros would help a bit.
|
...

Forgot to CC LKML, so I bounce the message to LKML and add
this reply with LKML CC'ed. Sorry.
 
		- Cyrill -
