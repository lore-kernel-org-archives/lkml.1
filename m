Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbZGTSLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbZGTSLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZGTSLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:11:08 -0400
Received: from outbound-mail-107.bluehost.com ([69.89.22.7]:57424 "HELO
	outbound-mail-107.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751822AbZGTSLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:11:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ASIWta0MmHWQRPF/9TLOWSSwk2Q1FvivxORGrL1Gg5dX64amMih3YJJrwrRmVXDORHYYgl9pZ1Z1FY8YJnaOfrITBHc5y/QwEBB0FYi8siknBu86ATML78AMSO4YTWT1;
Date: Mon, 20 Jul 2009 11:11:01 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, DRI <dri-devel@lists.sourceforge.net>,
       Michel =?UTF-8?B?RMOkbnplcg==?= <michel@daenzer.net>
Subject: Re: [Bug #12765] i915 VT switch with AIGLX causes X lock up
Message-ID: <20090720111101.659a9099@jbarnes-g45>
In-Reply-To: <20090628201129.GA1546@sucs.org>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera>
	<AN6kEAA5GQ.A.Q7C.Vm7KKB@chimera>
	<20090628201129.GA1546@sucs.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jun 2009 21:11:30 +0100
Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> On Sun, Jun 07, 2009 at 12:06:18PM +0200, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12765
> > Subject		: i915 VT switch with AIGLX causes X lock up
> > Submitter	: Sitsofe Wheeler <sitsofe@yahoo.com>
> > Date		: 2009-02-21 15:38 (107 days old)
> > First-Bad-Commit:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=14d200c5e5bd19219d930bbb9a5a22758c8f5bec
> > References	:
> > http://marc.info/?l=linux-kernel&m=123523074304955&w=4
> > http://lkml.org/lkml/2009/4/27/317 Handled-By	: Jesse Barnes
> > <jbarnes@virtuousgeek.org> Patch		:
> > http://patchwork.kernel.org/patch/20197/
> 
> Still here on 2.6.31-rc1 but...
> 
> ...this seems to be tied to the version of the Intel X drivers I have.
> On another install with more recent Intel X drivers I cannot reproduce
> this issue.

I guess we can mark it closed then, though I don't have the commit id
of the fix handy...

-- 
Jesse Barnes, Intel Open Source Technology Center
