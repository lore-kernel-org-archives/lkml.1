Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbYE3AlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbYE3AlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 20:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYE3AlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 20:41:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:34996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbYE3AlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 20:41:07 -0400
From: Neil Brown <neilb@suse.de>
To: corbet@lwn.net (Jonathan Corbet)
Date: Fri, 30 May 2008 10:40:54 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18495.19734.809962.497265@notabene.brown>
Cc: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project 
In-Reply-To: message from Jonathan Corbet on Thursday May 29
References: <1212041839.8888.38.camel@pasglop>
	<22351.1212077021@vena.lwn.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday May 29, corbet@lwn.net wrote:
> Ben H writes:
> 
> > On Wed, 2008-05-28 at 22:58 -0700, David Miller wrote:
> > > 
> > > Not to distract from your points, but I think it's been a huge
> > > mistake to not allow folks to work hard on technical issues
> > > during the summit.
> > 
> > Having been stopped a couple of times last year when trying to bring
> > some technical subjects for the reason that they were "off topic, KS is
> > for process" I tend to agree :-)
> 
> Here's an idea: the discussion list for the 2008 summit has opened up.
> This seems like an ideal time to make suggestions for technical topics
> which you think would be appropriate for this gathering.  Failing that,
> you leave it up to the program committee to try to guess what's on
> everybody's minds, and that seems certain to disappoint a lot of people.
> 

http://lwn.net/Articles/283161/

Barriers

What minimal semantics to Filesystem developers actually want?
What can hardware really provide?
What how can layered mutli-disk devices (md, dm, loop) mediate these?

What interface semantics can we come up with that are sufficiently
general and powerful that everyone will actually implement them
correctly?

However I won't be coming this year, so I won't be able to participate
directly in such a discussion.

NeilBrown
