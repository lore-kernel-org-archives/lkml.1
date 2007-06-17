Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbXFQPPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbXFQPPo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 11:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbXFQPPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 11:15:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57529 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbXFQPPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 11:15:32 -0400
Date: Sun, 17 Jun 2007 17:14:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, Dave Airlie <airlied@linux.ie>,
       Andrea Righi <righiandr@users.sourceforge.net>,
       Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
       Samuel Ortiz <samuel@sortiz.org>, Andrey Borzenkov <arvidjaar@mail.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Chad Tindel <ctindel@users.sourceforge.net>,
       Dan Aloni <da-x@monatomic.org>, Jay Vosburgh <fubar@us.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>, Paulo Pereira <pfmp.404@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [2/2] 2.6.22-rc5: known regressions with patches
Message-ID: <20070617151450.GA11762@elte.hu>
References: <4675430B.2000304@googlemail.com> <46754400.2080101@googlemail.com> <Line.LNX.4.64.0706171046190.1178@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0706171046190.1178@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* James Morris <jmorris@namei.org> wrote:

> > SELinux
> > 
> > Subject    : very high non-preempt latency in context_struct_compute_av()
> > References : http://lkml.org/lkml/2007/6/4/78
> > Submitter  : Ingo Molnar <mingo@elte.hu>
> > Handled-By : Stephen Smalley <sds@tycho.nsa.gov>
> >             James Morris <jmorris@namei.org>
> > Patch      : http://lkml.org/lkml/2007/6/7/334
> > Status     : patch available
> 
> This patch is queued for -mm, and will be submitted for 2.6.23.

and that is fine with me - think this is a pre-existing problem so not a 
new regression in .22.

	Ingo
