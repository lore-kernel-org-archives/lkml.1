Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbXGAWiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbXGAWiu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 18:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbXGAWil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 18:38:41 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:58291 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbXGAWik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 18:38:40 -0400
Date: Sun, 1 Jul 2007 18:38:37 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Adrian Bunk <bunk@stusta.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport mmap_min_addr
In-Reply-To: <20070701202353.GZ10869@stusta.de>
Message-ID: <Line.LNX.4.64.0707011838250.14811@d.namei>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
 <20070701202353.GZ10869@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jul 2007, Adrian Bunk wrote:

> On Thu, Jun 28, 2007 at 03:43:21AM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.22-rc4-mm2:
> >...
> >  git-selinux.patch
> >...
> >  git trees
> >...
> 
> 
> Unneeded export.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Thanks, applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm


-- 
James Morris
<jmorris@namei.org>
