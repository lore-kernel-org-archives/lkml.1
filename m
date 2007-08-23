Return-Path: <linux-kernel-owner+w=401wt.eu-S1759074AbXHWAZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074AbXHWAZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 20:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbXHWAZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 20:25:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbXHWAZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 20:25:37 -0400
Date: Wed, 22 Aug 2007 20:25:23 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, cpufreq@www.linux.org.uk,
       frank@harenberg.ch
Subject: Re: [Bugme-new] [Bug 8924] New: module speedstep-centrino does not
	load
Message-ID: <20070823002523.GE18739@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	linux-kernel@vger.kernel.org, cpufreq@www.linux.org.uk,
	frank@harenberg.ch
References: <bug-8924-10286@http.bugzilla.kernel.org/> <20070822164451.1481d745.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822164451.1481d745.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 04:44:51PM -0700, Andrew Morton wrote:
 > On Wed, 22 Aug 2007 15:12:09 -0700 (PDT)
 > bugme-daemon@bugzilla.kernel.org wrote:
 > 
 > > http://bugzilla.kernel.org/show_bug.cgi?id=8924
 > > 
 > >            Summary: module speedstep-centrino does not load
 > >            Product: Drivers
 > >            Version: 2.5
 > >      KernelVersion: 2.6.23-rc3
 > >           Platform: All
 > >         OS/Version: Linux
 > >               Tree: Mainline
 > >             Status: NEW
 > >           Severity: normal
 > >           Priority: P1
 > >          Component: Other
 > >         AssignedTo: drivers_other@kernel-bugs.osdl.org
 > >         ReportedBy: frank@harenberg.ch
 > > 
 > > 
 > > Most recent kernel where this bug did not occur:2.6.22
 > > Distribution:gentoo
 > > Hardware Environment: Intel Centrino Duo, cpu family 6, model 14, Model Name
 > > T2300 In a Dell Inspiron 9400.
 > > Software Environment: i386
 > > Problem Description: modprobe speedstep-centrino quits with error "no such
 > > device"
 > > same module loads successfully with older versions on the same computer.
 > > Steps to reproduce:
 > > modprobe speedstep-centrino
 > > 
 > 
 > I'd have thought that a lot of people would be seeing this?
 > 
 > Oh well.  Michal, can we please track this as a post-2.6.22 regression?

As mentioned in the now-closed bz, NOTABUG.

	Dave

-- 
http://www.codemonkey.org.uk
