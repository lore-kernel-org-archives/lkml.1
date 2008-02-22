Return-Path: <linux-kernel-owner+w=401wt.eu-S1759807AbYBVQ4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759807AbYBVQ4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYBVQ4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:56:38 -0500
Received: from rtr.ca ([76.10.145.34]:4310 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbYBVQ4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:56:37 -0500
Message-ID: <47BEFEC4.7090904@rtr.ca>
Date: Fri, 22 Feb 2008 11:56:36 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: david@lang.hm
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
 Screen becomes green.
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201241.30952.jesse.barnes@intel.com> <alpine.LFD.1.00.0802201256040.7833@woody.linux-foundation.org> <200802201344.11643.jesse.barnes@intel.com> <alpine.LFD.1.00.0802201355590.7833@woody.linux-foundation.org> <alpine.LFD.1.00.0802210819560.1777@xo-0C-FC-0F.localdomain>
In-Reply-To: <alpine.LFD.1.00.0802210819560.1777@xo-0C-FC-0F.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
..
> I've been watching for kexec hibernate for a little while now, and the 
> last I saw was that acpi was incompatible with the kexec hibernate (but 
> the suspend folks were still claiming that devices needed to be put in 
> the 'right mode' not just powered off. I've been waiting to see this 
> resolved.
..

Yeah, exactly.  What's so special about poweroff on hibernation?
Why even bother with the special "S4" state there?
I want a real full poweroff, or at least I think I do.  Why wouldn't I?

????
