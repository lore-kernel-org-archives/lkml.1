Return-Path: <linux-kernel-owner+w=401wt.eu-S1764952AbXHAOcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764952AbXHAOcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758715AbXHAOcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:32:41 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49743 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069AbXHAOck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:32:40 -0400
Date: Wed, 1 Aug 2007 08:32:39 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] drivers/scsi/advansys.c: fix advansys_board_found compile error
Message-ID: <20070801143239.GZ21219@parisc-linux.org>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <46B0842D.3060703@googlemail.com> <20070801133912.GA11027@kernel.sg> <20070801135515.GV21219@parisc-linux.org> <46B09843.7010701@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B09843.7010701@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 04:27:15PM +0200, Gabriel C wrote:
> Matthew Wilcox wrote:
> > I'd be interested in seeing the results of the randconfig trials on the
> > driver with those 23 patches applied, but not particularly interested in
> > the intermediate result.
> 
> I can do that on weekend.

Thanks

> Are the patches meant for -mm or git head ?

They were developed against git head as of a few days ago.  Here's a git
tree, if that's easier for you:

http://git.kernel.org/?p=linux/kernel/git/willy/advansys.git;a=shortlog

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
