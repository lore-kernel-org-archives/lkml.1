Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbYKTVh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbYKTVh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 16:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYKTVhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 16:37:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33548 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbYKTVhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 16:37:10 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, "K.S. Bhaskar" <ks.bhaskar@fnis.com>
Subject: Re: Enterprise workload testing for storage and filesystems
References: <1226962063.3403.13.camel@localhost.localdomain>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 20 Nov 2008 16:37:05 -0500
In-Reply-To: <1226962063.3403.13.camel@localhost.localdomain> (James
	Bottomley's message of "Tue, 18 Nov 2008 07:47:42 +0900")
Message-ID: <x49y6zegjum.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> Hi all,
>
> High on our list at the recent Linux Foundation end user summit was
> obtaining a method of obtaining enterprise workloads (or simulators) we
> can run in our own testing environments.  The main problem being that
> the data sets used by the systems are usually secret or under regulatory
> embargo and thus unobtainable.  However, several participants noted that
> regulatory prohibitions also extended to their own in-house IT team,
> thus they had had to develop simulators for the workloads which, since
> they contained no customer data, might be more widely distributable.
>
> Fidelity National Information Service were the first to try this.
> They've kicked off a sourceforge site for their stress testing tool
> (which is the same tool they use in their own qualification labs).  The
> source for the tool is available here:
>
> http://sourceforge.net/project/showfiles.php?group_id=11026&package_id=298597
>
> And it comes with a fairly detailed readme explaining what it's trying
> to simulate and why.  Hopefully this will give us all a much better
> insight into both enterprise workloads and the way enterprise IT
> departments conduct testing.
>
> Let's see how our storage and filesystem tuning measures up to this.

This is indeed great news!  The tool is very flexible, so I'd like to
know if we can get some sane configuration options to start testing.
I'm sure I can cook something up, but I'd like to be confident that what
I'm testing does indeed reflect a real-world workload.

Cheers,
Jeff
