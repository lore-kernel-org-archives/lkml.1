Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbYJPNVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbYJPNVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 09:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbYJPNVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 09:21:34 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:54591 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518AbYJPNVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 09:21:33 -0400
Message-ID: <48F73F92.8030201@csr.com>
Date: Thu, 16 Oct 2008 14:20:18 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] UWB, WUSB, and WLP subsystems for 2.6.28
References: <48EF45BC.1020805@csr.com> <20081014130251.aa008a5e.akpm@linux-foundation.org> <48F5E704.1070808@csr.com>
In-Reply-To: <48F5E704.1070808@csr.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2008 13:20:18.0261 (UTC) FILETIME=[EEF5A850:01C92F91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Vrabel wrote:
> 
> I can fix up some of the issues in the next couple of days (use
> time_after() and kcalloc()).  Could these subsystems then be merged?

Fixed.

> The printk_ratelimit() will take a bit longer.

I fixed some of these.  I need to think more on what's best to do with
the remaining ones.

Linus,

Can you pull these subsystems now from?

git://git.kernel.org/pub/scm/linux/kernel/git/dvrabel/uwb.git for-upstream

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
