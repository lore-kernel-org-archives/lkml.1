Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbXEAF10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbXEAF10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbXEAF10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:27:26 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57738 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbXEAF1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:27:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: vgoyal@in.ibm.com
Cc: Andi Kleen <ak@suse.de>, Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, Jurriaan <thunder7@xs4all.nl>,
       Helge Hafting <helgehaf@aitel.hist.no>, Horms <horms@verge.net.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] x86_64: Reflect the relocatability of the kernel in the ELF header.
References: <m1slah6gm0.fsf@ebiederm.dsl.xmission.com>
	<200704301717.08230.ak@suse.de> <20070501035539.GA15472@in.ibm.com>
	<m14pmx18ey.fsf@ebiederm.dsl.xmission.com>
	<20070501050657.GA23111@in.ibm.com>
Date: Mon, 30 Apr 2007 23:26:50 -0600
In-Reply-To: <20070501050657.GA23111@in.ibm.com> (Vivek Goyal's message of
	"Tue, 1 May 2007 10:36:57 +0530")
Message-ID: <m1zm4pyuzp.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@in.ibm.com> writes:


>> At least without a core file it is working on with gdb 6.4.
>>
>
> This seems to be a problem with gdb 6.5. I transferred the dump to a
> different machine having GNU gdb 6.4, and it works fine there.

Ok.  The difference between those two symbols didn't seem to make
any sense, so a gdb bug makes sense.

Cool.  Then the patch is good. :)

Eric
