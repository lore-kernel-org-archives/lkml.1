Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbXJ1OX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbXJ1OX1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 10:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbXJ1OXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 10:23:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:52567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbXJ1OXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 10:23:17 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [AppArmor 00/45] AppArmor security module overview
Date: Sun, 28 Oct 2007 15:25:10 +0100
User-Agent: KMail/1.9.5
Cc: Arjan van de Ven <arjan@infradead.org>, jjohansen@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
References: <20071026064024.243943043@suse.de> <20071026073721.618b4778@laptopd505.fenrus.org> <20071027204735.GA350@infradead.org>
In-Reply-To: <20071027204735.GA350@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710281525.11245.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 October 2007 22:47, Christoph Hellwig wrote:
> On Fri, Oct 26, 2007 at 07:37:21AM -0700, Arjan van de Ven wrote:
> > before going into the LSM / security side of things, I'd like to get
> > the VFS guys to look at your VFS interaction code.
> 
> It's been NACKed a few times, and just reposting it won't help.

Let me repeat what I have said before in another context. The past discussions 
on linux-kernel were useful for a while, and we got constructive feedback 
which we could act upon, but then the feedback became very non-constructive 
again, and you NACKed patches without giving any good reasons. I have asked 
for specific feedback but didn't get any in:

 - Rejecting the vfsmount additions,
   http://marc.info/?l=linux-kernel&m=118350187712375

 - VFS layering fuck-up accusation,
   http://marc.info/?l=linux-kernel&m=118348050804600

So can we pick up things there again, and have a real discussion about the 
things you criticize?

Thanks,
Andreas
