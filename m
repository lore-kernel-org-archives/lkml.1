Return-Path: <linux-kernel-owner+w=401wt.eu-S1763636AbXEYQzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763636AbXEYQzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbXEYQy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:54:56 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43912 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbXEYQyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:54:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <ak@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@ninex.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, ninex@o2.pl,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>,
       len.brown@intel.com
Subject: Re: [PATCH 2/2] msi:  Add support for the Intel chipsets that support MSI.
References: <200705122146.l4CLkH6q012322@fire-2.osdl.org>
	<m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6p5cyut.fsf_-_@ebiederm.dsl.xmission.com>
	<200705250738.57066.ak@suse.de>
	<m17iqxcu27.fsf@ebiederm.dsl.xmission.com> <4656F5BD.40800@redhat.com>
Date: Fri, 25 May 2007 10:52:54 -0600
In-Reply-To: <4656F5BD.40800@redhat.com> (Chuck Ebbert's message of "Fri, 25
	May 2007 10:42:05 -0400")
Message-ID: <m1veegalqx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert <cebbert@redhat.com> writes:

> http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f8993aff8b4de0317c6e081802ca5c86c449fef2
> Commit:     f8993aff8b4de0317c6e081802ca5c86c449fef2
> Parent:     a23cf14b161b8deeb0f701d577a0e8be6365e247
> Author:     Shaohua Li <shaohua.li@intel.com>
> AuthorDate: Wed Apr 25 11:05:12 2007 +0800
> Committer:  Len Brown <len.brown@intel.com>
> CommitDate: Wed Apr 25 01:13:47 2007 -0400
>
>     ACPI: Disable MSI on request of FADT

Interesting.  I'm going to have to read up on this bit.
Perhaps it is enough.

Eric
