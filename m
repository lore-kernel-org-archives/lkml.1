Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbYHFQdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbYHFQdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 12:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbYHFQZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 12:25:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbYHFQZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 12:25:23 -0400
Date: Wed, 6 Aug 2008 12:25:00 -0400
From: Rik van Riel <riel@redhat.com>
To: tvrtko.ursulin@sophos.com
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       Theodore Tso <tytso@MIT.EDU>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
 access scanning
Message-ID: <20080806122500.538c3fc6@cuia.bos.redhat.com>
In-Reply-To: <20080806161350.0660837659D@pmx1.sophos.com>
References: <20080806114604.5a714d11@cuia.bos.redhat.com>
	<20080806161350.0660837659D@pmx1.sophos.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008 17:12:56 +0100
tvrtko.ursulin@sophos.com wrote:
> Rik van Riel wrote on 06/08/2008 16:46:04:

> > More importantly, getting info on which bytes in a file changed
> > will also help backup programs and disk indexing programs.
> 
> True, but Nick mentioned some huge issues with access after close and 
> munmap in one of your previous postings. It sounds to me that would be a 
> huge VM/filesystem work to actually enable things like this.

A universally useful large change is often easier to get into
the Linux kernel than a single-purpose hack.

-- 
All Rights Reversed
