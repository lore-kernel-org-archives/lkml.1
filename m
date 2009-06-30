Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbZF3JOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbZF3JOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 05:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbZF3JOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 05:14:18 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:52892 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZF3JOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 05:14:18 -0400
Date: Tue, 30 Jun 2009 11:16:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [Patch] kbuild: finally remove the obsolete variable $TOPDIR
Message-ID: <20090630091638.GA12926@uranus.ravnborg.org>
References: <20090619074241.6646.42298.sendpatchset@localhost.localdomain> <20090630090639.GA5873@cr0.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630090639.GA5873@cr0.nay.redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 05:06:39PM +0800, Amerigo Wang wrote:
> On Fri, Jun 19, 2009 at 03:40:26AM -0400, Amerigo Wang wrote:
> >
> >TOPDIR is obsolete, it can be finally removed now.
> >
> >Signed-off-by: WANG Cong <amwang@redhat.com>
> >Cc: Sam <sam@ravnborg.org>
> 
> ping Sam...
http://git.kernel.org/?p=linux/kernel/git/sam/kbuild-fixes.git;a=commit;h=112942353992d95099fb5b71c679ff1046fccfcf

Seems I forgot to send you an "applied" mail.

	Sam
