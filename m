Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZEGSsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZEGSsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZEGSru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:47:50 -0400
Received: from waste.org ([66.93.16.53]:53111 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbZEGSrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:47:49 -0400
Date: Thu, 7 May 2009 13:42:54 -0500
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Florian Weimer <fweimer@bfk.de>, security@kernel.org,
       Roland McGrath <roland@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, Jake Edge <jake@lwn.net>,
       linux-security-module@vger.kernel.org, mingo@redhat.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dave Jones <davej@redhat.com>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged processes
Message-ID: <20090507184254.GM31071@waste.org>
References: <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506175717.GY31071@waste.org> <82prel54fo.fsf@mid.bfk.de> <20090507165545.GK31071@waste.org> <alpine.LFD.2.01.0905071040130.4983@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905071040130.4983@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 10:53:49AM -0700, Linus Torvalds wrote:
> So Matt, get with the program already. Don't ignore the performance 
> argument by saying "it's only twice as slow". Admit it - that's just 
> idiotic.

If you want to take it out of random.c and put it in pinhead-rng.c, be
my guest. I'm not going to put my Acked-by on it.

-- 
Mathematics is the supreme nostalgia of our time.
