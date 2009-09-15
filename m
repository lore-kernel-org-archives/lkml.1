Return-Path: <linux-kernel-owner+w=401wt.eu-S1751440AbZIOEiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbZIOEiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 00:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZIOEiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 00:38:17 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:40803 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbZIOEiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 00:38:16 -0400
Date: Mon, 14 Sep 2009 21:35:23 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Fasheh <mfasheh@suse.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ocfs2-devel@oss.oracle.com
Subject: Re: [GIT PULL] ocfs2 changes for 2.6.32
Message-ID: <20090915043523.GF4507@mail.oracle.com>
Mail-Followup-To: Arjan van de Ven <arjan@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com
References: <20090911200458.GA15416@mail.oracle.com>
 <alpine.LFD.2.01.0909141417180.4950@localhost.localdomain>
 <20090914221434.GA4507@mail.oracle.com>
 <alpine.LFD.2.01.0909141614350.4950@localhost.localdomain>
 <20090915000417.GC4507@mail.oracle.com>
 <alpine.LFD.2.01.0909141727150.4950@localhost.localdomain>
 <20090915005417.GD4507@mail.oracle.com>
 <alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
 <20090915060559.5b0a2574@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915060559.5b0a2574@infradead.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4AAF1A27.002F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 06:05:59AM +0200, Arjan van de Ven wrote:
> COW filesystems like btrfs may also be able to do interesting things
> with copyfile() btw by just sharing all data blocks COW.
> 
> That would make copyfile() useful for me, much more so than the network
> filesystem side...

	btrfs reflink is definitely in the cards.

Joel

-- 

"The first thing we do, let's kill all the lawyers."
                                        -Henry VI, IV:ii

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
