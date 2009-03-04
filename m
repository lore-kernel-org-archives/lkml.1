Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZCDIBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZCDIBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 03:01:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZCDIAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 03:00:49 -0500
Received: from mail.gmx.net ([213.165.64.20]:49573 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753079AbZCDIAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 03:00:48 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+4kIh2+w+4pKa5lkacBUSC4lrc+YuCvQayPUVp8B
	VwTy9qnG80eZb5
Subject: Re: Large amount of scsi-sgpool objects
From: Mike Galbraith <efault@gmx.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jan Engelhardt <jengelh@medozas.de>,
       Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <49AE32B5.9040603@s5r6.in-berlin.de>
References: <49ACF8FE.2020904@panasas.com>
	 <1236093718.3263.3.camel@localhost.localdomain>
	 <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr>
	 <1236097526.3263.17.camel@localhost.localdomain>
	 <20090303192212.GA20705@elte.hu>
	 <1236115544.15993.22.camel@localhost.localdomain>
	 <20090303214454.GA8288@elte.hu>
	 <1236119990.24019.35.camel@localhost.localdomain>
	 <20090303230323.GA21644@elte.hu> <49ADBE29.4040706@s5r6.in-berlin.de>
	 <20090303234834.GA13389@elte.hu>  <49AE221D.9010909@s5r6.in-berlin.de>
	 <1236150752.6049.19.camel@marge.simson.net>
	 <49AE32B5.9040603@s5r6.in-berlin.de>
Content-Type: text/plain; charset=utf-8
Date: Wed, 04 Mar 2009 09:00:40 +0100
Message-Id: <1236153640.6729.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 08:50 +0100, Stefan Richter wrote:
> Mike Galbraith wrote:
> > On Wed, 2009-03-04 at 07:39 +0100, Stefan Richter wrote:
> >> Ingo Molnar wrote:
> >>> Yeah, these commits are in none of the topic branches that are 
> >>> the git base of development, they are all already in a separate 
> >>> branch named "tip:out-of-tree".
> >> So people should remember to retry without out-of-tree before reporting
> >> problems == remember to report against the development base.
> > 
> > I'll bite, how does a gut-fu white belt accomplish that?
> 
> How to do it is currently not quite obvious
>   - for linux-2.6-x86.git users because the master branch contains
>     out-of-tree.¹  Or maybe nobody should use the master branch,
>     I don't know.

Ah, ok.  I thought there might be an un-merge incantation or whatnot.

(seems to have just been an oopsie anyway)

	-Mike

