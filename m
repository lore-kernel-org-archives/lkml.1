Return-Path: <linux-kernel-owner+w=401wt.eu-S932131AbXBNBbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbXBNBbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 20:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbXBNBbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 20:31:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbXBNBbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 20:31:04 -0500
Message-ID: <45D264D0.4080904@redhat.com>
Date: Tue, 13 Feb 2007 20:24:32 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: eranian@hpl.hp.com, perfmon@napali.hpl.hp.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       perfctr-devel@lists.sourceforge.net
Subject: Re: 2.6.20 new perfmon code base + libpfm + pfmon
References: <20070213184839.GC10031@frankl.hpl.hp.com> <20070213140533.a5ca27ad.akpm@linux-foundation.org>
In-Reply-To: <20070213140533.a5ca27ad.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> On Tue, 13 Feb 2007 10:48:39 -0800 Stephane Eranian <eranian@hpl.hp.com> wrote:
>> I have released another version of the perfmon new code base package.
> 
> Can we have a bug push to get this merged up please?

You mean "big" push? :)

FWIW I ran 2.6.17.8 kernels for weeks with the perfmon
patches applied and had no problems, so it does seem
reasonably stable to me.

