Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbYHXT2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbYHXT2J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 15:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYHXT14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 15:27:56 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:43702 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbYHXT14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 15:27:56 -0400
Date: Sun, 24 Aug 2008 22:27:18 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #11254] KVM: fix userspace ABI breakage
Message-ID: <20080824192714.GC1627@cs181140183.pp.htv.fi>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.mGB.TcGsIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <VSpL6AnBTS.A.mGB.TcGsIB@albercik>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2008 at 08:10:16PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11254
> Subject		: KVM: fix userspace ABI breakage
> Submitter	: Adrian Bunk <bunk@kernel.org>
> Date		: 21 Jul 2008 17:58:26 (0 days old)
> References	: http://lkml.org/lkml/2008/7/21/197
> Handled-By	: Adrian Bunk <bunk@kernel.org>
> Patch		: http://lkml.org/lkml/2008/7/21/197

The discussion in Bugzilla whether it is a regression at all can be 
condensed to the following question:

Can a struct that is part of the 2.6.26 userspace headers be defined to 
be part of an "experimental ABI" and therefore be changed?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

