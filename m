Return-Path: <linux-kernel-owner+w=401wt.eu-S1760197AbYHFSHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbYHFSHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 14:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbYHFSGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 14:06:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbYHFSGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 14:06:39 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
	access scanning
From: Eric Paris <eparis@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: tvrtko.ursulin@sophos.com, Theodore Tso <tytso@MIT.EDU>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20080806122500.538c3fc6@cuia.bos.redhat.com>
References: <20080806114604.5a714d11@cuia.bos.redhat.com>
	 <20080806161350.0660837659D@pmx1.sophos.com>
	 <20080806122500.538c3fc6@cuia.bos.redhat.com>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 14:06:29 -0400
Message-Id: <1218045989.27684.257.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 12:25 -0400, Rik van Riel wrote:
> On Wed, 6 Aug 2008 17:12:56 +0100
> tvrtko.ursulin@sophos.com wrote:
> > Rik van Riel wrote on 06/08/2008 16:46:04:
> 
> > > More importantly, getting info on which bytes in a file changed
> > > will also help backup programs and disk indexing programs.
> > 
> > True, but Nick mentioned some huge issues with access after close and 
> > munmap in one of your previous postings. It sounds to me that would be a 
> > huge VM/filesystem work to actually enable things like this.
> 
> A universally useful large change is often easier to get into
> the Linux kernel than a single-purpose hack.

Over engineering in a void for some supposed someday user isn't a good
idea either.  If there are other people interested in working together
to come up with a solution to multiple needs I'm here to help!

-Eric

