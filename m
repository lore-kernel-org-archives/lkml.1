Return-Path: <linux-kernel-owner+w=401wt.eu-S933309AbXHVXpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309AbXHVXpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 19:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763809AbXHVXpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 19:45:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54940 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763032AbXHVXpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 19:45:05 -0400
Date: Wed, 22 Aug 2007 16:44:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       cpufreq@www.linux.org.uk, frank@harenberg.ch
Subject: Re: [Bugme-new] [Bug 8924] New: module speedstep-centrino does not
 load
Message-Id: <20070822164451.1481d745.akpm@linux-foundation.org>
In-Reply-To: <bug-8924-10286@http.bugzilla.kernel.org/>
References: <bug-8924-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 15:12:09 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8924
> 
>            Summary: module speedstep-centrino does not load
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.23-rc3
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: drivers_other@kernel-bugs.osdl.org
>         ReportedBy: frank@harenberg.ch
> 
> 
> Most recent kernel where this bug did not occur:2.6.22
> Distribution:gentoo
> Hardware Environment: Intel Centrino Duo, cpu family 6, model 14, Model Name
> T2300 In a Dell Inspiron 9400.
> Software Environment: i386
> Problem Description: modprobe speedstep-centrino quits with error "no such
> device"
> same module loads successfully with older versions on the same computer.
> Steps to reproduce:
> modprobe speedstep-centrino
> 

I'd have thought that a lot of people would be seeing this?

Oh well.  Michal, can we please track this as a post-2.6.22 regression?

Thanks.
