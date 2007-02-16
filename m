Return-Path: <linux-kernel-owner+w=401wt.eu-S966215AbXBPI0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966215AbXBPI0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 03:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966214AbXBPI0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 03:26:06 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52421 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966215AbXBPI0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 03:26:05 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ian Campbell <Ian.Campbell@XenSource.com>
Cc: Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Ian Pratt <ian.pratt@XenSource.com>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and disable unsupported config options.
References: <20070216022449.739760547@goop.org>
	<20070216022531.570154735@goop.org> <45D54BFF.80100@vmware.com>
	<m11wkqimjd.fsf@ebiederm.dsl.xmission.com>
	<1171613663.20666.30.camel@localhost.localdomain>
Date: Fri, 16 Feb 2007 01:24:14 -0700
In-Reply-To: <1171613663.20666.30.camel@localhost.localdomain> (Ian Campbell's
	message of "Fri, 16 Feb 2007 08:14:22 +0000")
Message-ID: <m1ire2h5n5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell <Ian.Campbell@XenSource.com> writes:

> On Fri, 2007-02-16 at 00:33 -0700, Eric W. Biederman wrote:
>> I know there actually has been some work to get kexec actually working under
>> Xen but I don't know where that has gone.
>
> kexec/kdump works with Xen 3.0.4 but it's a dom0 only thing so it
> doesn't appear in this patchset.

Ok but we still need to get the failure to user space for domU instead
of trying what works on real hardware and failing.

Eric
