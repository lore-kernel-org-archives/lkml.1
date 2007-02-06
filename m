Return-Path: <linux-kernel-owner+w=401wt.eu-S964771AbXBFAEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964771AbXBFAEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964806AbXBFAEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:04:09 -0500
Received: from wr-out-0506.google.com ([64.233.184.226]:20740 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964830AbXBFAEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:04:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:in-reply-to:references:mime-version:content-type:message-id:cc:content-transfer-encoding:subject:date:to:x-mailer:from;
        b=RDTYS1DStanLpFKuB7wCuc2PkBDLrixm1j/b0VVUDQilPY32q9mH28z68KsKMEMX37kcpz7WgOtDgLfC3AdK9V/OPCMXCczS/9WhiPzJgR+4JQuhSWKNJ/XqMkaU1cAOyIu0VepKW6ntAQ+4G5GJ90mp2hUCupqwbUcxoa1o2gI=
In-Reply-To: <Pine.LNX.4.64.0702051525320.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>  <20070205084523.GA21858@elte.hu>  <1170682488.29759.795.camel@pmac.infradead.org> <20070205155627.GA8354@elte.hu>  <1170692539.29759.856.camel@pmac.infradead.org> <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu>  <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>  <1170710272.29759.894.camel@pmac.infradead.org>  <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>  <1170711587.29759.909.camel@pmac.infradead.org>  <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org>  <1170712393.29759.925.camel@pmac.infradead.org>  <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org>  <20070205143110.fca62b57.randy.dunlap@oracle.com>  <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org> <1170717694.29759.941.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051525320.8424@woody.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A77CFAF3-DFCF-44B5-8917-364D3498DB1A@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Date: Mon, 5 Feb 2007 18:04:05 -0600
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.752.2)
From: Mark Rustad <mrustad@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 5, 2007, at 5:32 PM, Linus Torvalds wrote:

<snip>

> And I told you that you could just improve the tools that track those
> dependencies ANYWAY!

They aren't that bad even now. Using menuconfig (I'm a fossil that  
just uses curses for most things), hitting ? shows what depends or  
selects any particular entry. That is good enough for me now. Maybe I  
am just willing to ask for help, but the help already seems to be there.

<snip>

-- 
Mark Rustad, MRustad@gmail.com


