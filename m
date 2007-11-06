Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbXKFIOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbXKFIOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 03:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbXKFIOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 03:14:31 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:51374 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbXKFIOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 03:14:31 -0500
Date: Tue, 6 Nov 2007 00:14:13 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [RFC] kobject and kset core changes and cleanups
Message-ID: <20071106081413.GA12542@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071102235758.GA9803@kroah.com> <20071105231148.4f1bd0b1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105231148.4f1bd0b1.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, Greg,

On Mon, Nov 05, 2007 at 11:11:48PM -0800, Andrew Morton wrote:
> On Fri, 2 Nov 2007 16:57:58 -0700 Greg KH <gregkh@suse.de> wrote:
> 
> > So, I go on vacation for a week or so and come back to an overflowing
> > inbox.  Instead of trying to wade through all of that, I decide to
> > finish up the work Kay and I had started on cleaning up the kset core
> > code.
> 
> you killed perfmon.
> 
> perfmon/perfmon_sysfs.c: In function 'pfm_init_sysfs':
> perfmon/perfmon_sysfs.c:411: error: 'kernel_subsys' undeclared (first use in this function)
> perfmon/perfmon_sysfs.c:411: error: (Each undeclared identifier is reported only once
> perfmon/perfmon_sysfs.c:411: error: for each function it appears in.)
> 
> I'll drop the perfmon tree and shall soldier on.  

I am sure we can fix this. I just need to get the kset patch from Greg.


-- 

-Stephane
