Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbYCTPPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbYCTPPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 11:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbYCTPP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 11:15:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51339 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086AbYCTPP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 11:15:26 -0400
Date: Thu, 20 Mar 2008 12:14:59 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, v4l-dvb-maintainer@linuxtv.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Dan Williams <dan.j.williams@intel.com>,
       Paul Mackerras <paulus@samba.org>, <linuxppc-dev@ozlabs.org>,
       Theodore Tso <tytso@MIT.EDU>
Subject: Re: linux-next: Tree for March 20
Message-ID: <20080320121459.381e73eb@gaivota>
In-Reply-To: <20080319212121.9705ca9a.randy.dunlap@oracle.com>
References: <20080320143953.8d6b5a60.sfr@canb.auug.org.au>
	<20080319212121.9705ca9a.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008 21:21:21 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Thu, 20 Mar 2008 14:39:53 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> > (tar balls at
> > http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).
> 
> gcc doesn't like nested /* comments:
> 
> next-20080320/drivers/media/video/bt8xx/bttv-cards.c:3030:38: warning: "/*" within comment
> next-20080320/drivers/media/video/bt8xx/bttv-cards.c:3032:20: warning: "/*" within comment

Andrew already did a patch for this. I'll import on my tree.

> 
> ---
> ~Randy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/




Cheers,
Mauro
