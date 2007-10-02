Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbXJBPDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbXJBPDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXJBPDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:03:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40506 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbXJBPDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:03:45 -0400
Date: Tue, 2 Oct 2007 17:03:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John Stoffel <john@stoffel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Message-ID: <20071002150338.GA15450@elte.hu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <18178.22876.980673.839094@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18178.22876.980673.839094@stoffel.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stoffel <john@stoffel.org> wrote:

> 
> Linus> I said I was hoping that -rc8 was the last -rc, and I hate
> Linus> doing this, but we've had more changes since -rc8 than we had
> Linus> in -rc8. And while most of them are pretty trivial, I really
> Linus> couldn't face doing a 2.6.23 release and take the risk of some
> Linus> really stupid brown-paper-bag thing.
> 
> Linus> So there's a final -rc out there, and right now my plan is to
> Linus> make this series really short, and release 2.6.23 in a few
> Linus> days. So please do give it a last good testing, and holler
> Linus> about any issues you find!
> 
> Just to let people know, I was running 2.6.23-rc for over 53 days 
> without any issues.  Mix of SCSI, Sata, tape drives, disks, MD, LVM, 
> SMP, etc.  I suspect we've got a pretty darn stable release coming out 
> soon.

that's pretty impressive! v2.6.23-rc2, right?

	Ingo
