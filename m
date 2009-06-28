Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbZF1ULi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbZF1ULi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 16:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbZF1ULa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 16:11:30 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:48632 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbZF1UL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 16:11:29 -0400
Date: Sun, 28 Jun 2009 21:11:30 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, DRI <dri-devel@lists.sourceforge.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Subject: Re: [Bug #12765] i915 VT switch with AIGLX causes X lock up
Message-ID: <20090628201129.GA1546@sucs.org>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera> <AN6kEAA5GQ.A.Q7C.Vm7KKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AN6kEAA5GQ.A.Q7C.Vm7KKB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 12:06:18PM +0200, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12765
> Subject		: i915 VT switch with AIGLX causes X lock up
> Submitter	: Sitsofe Wheeler <sitsofe@yahoo.com>
> Date		: 2009-02-21 15:38 (107 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=14d200c5e5bd19219d930bbb9a5a22758c8f5bec
> References	: http://marc.info/?l=linux-kernel&m=123523074304955&w=4
> 		  http://lkml.org/lkml/2009/4/27/317
> Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
> Patch		: http://patchwork.kernel.org/patch/20197/

Still here on 2.6.31-rc1 but...

...this seems to be tied to the version of the Intel X drivers I have.
On another install with more recent Intel X drivers I cannot reproduce
this issue.

-- 
Sitsofe | http://sucs.org/~sits/
