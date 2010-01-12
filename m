Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739Ab0ALSO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab0ALSO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 13:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652Ab0ALSO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 13:14:58 -0500
Received: from outbound-mail-155.bluehost.com ([67.222.39.35]:49718 "HELO
	outbound-mail-155.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751621Ab0ALSO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 13:14:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=NpCEn5xyiRqWo5H4qTQ3UnZqOG9fGfiRav4OV1zIGo+8mR+yhTlkDzDVeigNQUv4pTBcm9KYM4mwHQepoZ2iB2HAPM6vhYQWVqhld2XvJGi4vNQHB7+gqPFGb4A7UIQ8;
Date: Tue, 12 Jan 2010 10:14:46 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: davidjon@xenontk.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>
Subject: Re: [Bug #14897] i915: Commit 0e442c60 causes flickering
Message-ID: <20100112101446.7fac096e@jbarnes-piketon>
In-Reply-To: <201001112052.57339.rjw@sisk.pl>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
	<CXIfLt-ygXM.A.DAC.zglSLB@chimera>
	<4B4AB589.7080004@xenontk.org>
	<201001112052.57339.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jan 2010 20:52:57 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday 11 January 2010, David John wrote:
> > On 01/11/2010 04:26 AM, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a
> > > report of regressions introduced between 2.6.31 and 2.6.32.
> > > 
> > > The following bug entry is on the current list of known
> > > regressions introduced between 2.6.31 and 2.6.32.  Please verify
> > > if it still should be listed and let me know (either way).
> > > 
> > > 
> > > Bug-Entry	:
> > > http://bugzilla.kernel.org/show_bug.cgi?id=14897
> > > Subject		: i915: Commit 0e442c60 causes flickering
> > > Submitter	: David John <davidjon@xenontk.org>
> > > Date		: 2009-12-09 17:26 (33 days old)
> > > First-Bad-Commit:
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0e442c60dd39ac6924b11a20497734bd2303744c
> > > References	:
> > > http://marc.info/?l=linux-kernel&m=126037889600769&w=4
> > > 
> > > 
> > > 
> > 
> > Still present in 2.6.33-rc3.
> 
> Thanks for the update.

David I guess you weren't on the bug cc list so you didn't see Yakui's
question.  I just attached a patch to it as well.  Please check it out.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
