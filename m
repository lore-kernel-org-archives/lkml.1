Return-Path: <linux-kernel-owner+w=401wt.eu-S1760202AbYDKLNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202AbYDKLNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 07:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759490AbYDKLNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 07:13:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37155 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759492AbYDKLNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 07:13:22 -0400
Date: Fri, 11 Apr 2008 20:17:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.25-rc8-mm2
Message-Id: <20080411201724.e820122b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080411195738.16e9ef92.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
	<20080411185703.a5407940.kamezawa.hiroyu@jp.fujitsu.com>
	<20080411192346.6872472a.kamezawa.hiroyu@jp.fujitsu.com>
	<1207910058.7212.1.camel@haji>
	<20080411195738.16e9ef92.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 19:57:38 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > What happens when it doesn't boot? Does it hang or do you get an oops?
> just hangs. before showing anything.
> 
> 
> > Can you reproduce it with the 'for-mm' branch of:
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git
> > 
> 
> will try. 
> 
slab-2.6.git booted well :(
Hmm, It seems I have to dig somewhere different...

Thanks,
-Kame 

