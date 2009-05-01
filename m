Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbZEAMF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbZEAMF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbZEAMFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:05:47 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:39626 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbZEAMFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:05:47 -0400
Date: Fri, 1 May 2009 14:07:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tim Abbott <tabbott@MIT.EDU>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/11] section name cleanup for x86
Message-ID: <20090501120757.GA23672@uranus.ravnborg.org>
References: <1241136098-10376-1-git-send-email-tabbott@mit.edu> <20090501115849.GB24706@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501115849.GB24706@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 01:58:49PM +0200, Ingo Molnar wrote:
> 
> * Tim Abbott <tabbott@MIT.EDU> wrote:
> 
> > This patch series cleans up the section names on the x86
> > architecture.  It requires the architecture-independent macro
> > definitions from this patch series:
> > 
> > <http://www.spinics.net/lists/mips/msg33499.html>
> 
> Hm, we cannot pick the x86 bits up into the x86 tree without having 
> these macros upstream first. So those macros need acks from Sam and 
> maybe Linus will take them out of order. (they are pure additions so 
> they look fairly safe and uncontroversial)

Thats the plan.

	Sam
