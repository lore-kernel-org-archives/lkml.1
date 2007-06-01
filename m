Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbXFAWxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbXFAWxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbXFAWx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:53:28 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:15291 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbXFAWx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:53:27 -0400
Date: Fri, 1 Jun 2007 15:53:15 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1 - page_mkwrite() breakage
Message-ID: <20070601225315.GZ20632@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070601010129.GA15878@wotan.suse.de> <20070601012440.GS20632@ca-server1.us.oracle.com> <20070601013402.GB28585@wotan.suse.de> <20070601014517.GT20632@ca-server1.us.oracle.com> <20070601015349.GC28585@wotan.suse.de> <20070601052039.GU20632@ca-server1.us.oracle.com> <20070601220117.GW20632@ca-server1.us.oracle.com> <20070601152537.a04209ff.akpm@linux-foundation.org> <20070601223302.GY20632@ca-server1.us.oracle.com> <20070601154735.197b663f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601154735.197b663f.akpm@linux-foundation.org>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 03:47:35PM -0700, Andrew Morton wrote:
> Right.  I did a lot of tricksy work for rc3-mm1 to merge git-ocfs2 on top
> of Nick's stuff.  Then I repulled your tree and lost it all.  This is
> because I was dumb and I fixed rc3-mm1's git-ocfs.patch rather than doing a
> separate fix-rejects-in-git-ocfs2.patch.
> 
> This is all unique-to-akpm stuff which you don't need to worry about ;)

Ok, I am no longer concerned! :)


> > So, which of Nick's patches are we talking about here?
> > 
> > Btw, I know you tend to handle rejects yourself, but if it's a major PITA
> > I'd be happy to help out. Boy, I'm hoping I didn't just ask for a load of
> > trouble there :)
> 
> Is OK - I'll move Nick's patches back to behind the git trees and it'll all come
> good.

Phew ok. Once again, thanks for all the work you do getting the ocfs2 git
patches into -mm.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
