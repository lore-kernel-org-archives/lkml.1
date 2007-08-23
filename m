Return-Path: <linux-kernel-owner+w=401wt.eu-S933911AbXHWAE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911AbXHWAE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 20:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932608AbXHWAEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 20:04:50 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:46802 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932493AbXHWAEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 20:04:50 -0400
From: Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 8924] New: module speedstep-centrino does not load
Date: Thu, 23 Aug 2007 03:06:09 +0300
User-Agent: KMail/1.9.7
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       cpufreq@www.linux.org.uk, frank@harenberg.ch
References: <bug-8924-10286@http.bugzilla.kernel.org/> <20070822164451.1481d745.akpm@linux-foundation.org>
In-Reply-To: <20070822164451.1481d745.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708230306.09815.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 August 2007 02:44:51 Andrew Morton wrote:
> On Wed, 22 Aug 2007 15:12:09 -0700 (PDT)
>
> bugme-daemon@bugzilla.kernel.org wrote:
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
> > Hardware Environment: Intel Centrino Duo, cpu family 6, model 14, Model
> > Name T2300 In a Dell Inspiron 9400.
> > Software Environment: i386
> > Problem Description: modprobe speedstep-centrino quits with error "no
> > such device"
> > same module loads successfully with older versions on the same computer.
> > Steps to reproduce:
> > modprobe speedstep-centrino
>
> I'd have thought that a lot of people would be seeing this?
>
> Oh well.  Michal, can we please track this as a post-2.6.22 regression?

Also can be reproduced on "Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz, 
cpu family 6, model 15" . Btw acpi-cpufreq works fine.

Regards,
ismail

-- 
Perfect is the enemy of good
