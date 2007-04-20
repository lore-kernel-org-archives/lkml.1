Return-Path: <linux-kernel-owner+w=401wt.eu-S1422727AbXDTFWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422727AbXDTFWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 01:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422751AbXDTFWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 01:22:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422727AbXDTFWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 01:22:40 -0400
Date: Fri, 20 Apr 2007 01:19:08 -0400
From: Dave Jones <davej@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de
Subject: Re: [2/2] 2.6.21-rc7: known regressions
Message-ID: <20070420051908.GH20566@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>, Adrian Bunk <bunk@stusta.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	pavel@suse.cz, linux-pm@lists.osdl.org,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070416003723.GM3691@stusta.de> <4628482B.6040804@goop.org> <20070420050344.GG20566@redhat.com> <46284C84.6060301@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46284C84.6060301@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 10:15:48PM -0700, Jeremy Fitzhardinge wrote:
 > Dave Jones wrote:
 > > Do you have the backlight code enabled ?
 > > I'm guessing not.
 > >   
 > 
 > Hm, think so.  backlight controls work, via both
 > /proc/acpi/ibm/backlight and /sys/class/backlight/*/brightness.
 > 
 > $ ls -l /sys/class/backlight/
 > total 0
 > drwxr-xr-x 2 root root 0 Apr 19 22:13 acpi_video0
 > drwxr-xr-x 2 root root 0 Apr 19 22:13 acpi_video1
 > drwxr-xr-x 2 root root 0 Apr 19 22:13 ibm

Hmm, given you hit the hpet problems and I didn't I think our X60's
aren't quite so similar.  Mine is the one with the swivelly touchscreen
tablet-pc mode. I understand they made a regular 'laptop' X60 too,
is that the one you have perhaps?

	Dave

-- 
http://www.codemonkey.org.uk
