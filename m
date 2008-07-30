Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbYG3UGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbYG3UGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYG3UGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:06:00 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59218 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbYG3UF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:05:59 -0400
Date: Wed, 30 Jul 2008 14:05:56 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Eric Weaver <eweaver@iecsolutions.com>
Cc: willy@linux.intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: gcc 3.3-3.4 failing on "intelcache"
Message-ID: <20080730200555.GA14245@parisc-linux.org>
References: <4890A085.5080005@iecsolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4890A085.5080005@iecsolutions.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 05:10:29PM +0000, Eric Weaver wrote:
> In regards to  compiling Linux 2.6.27-rc1,
> Gcc 3.3.2, 3.3.5, 3.4.x complains there is a failure on   "intelcache" 

I don't even know what you're talking about.  I can't find the string
'intelcache' in the current version of the kernel.  If you want some help,
the exact error messages would be useful.  These are quite old versions
of GCC, many people are using 4.x versions of the compiler.

>  I am aiming for a kernel that can become island synchronized with NTP. 
>   Seems kernels after 2.6.15?ish  began losing time.  Tried   HZ=100, 
> CPU=586TSC , no apic, no acpi.
> Any hunches were to begin?

No, I don't know anything about NTP, and I'm not a timekeeping expert in
general.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
