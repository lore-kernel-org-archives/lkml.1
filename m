Return-Path: <linux-kernel-owner+w=401wt.eu-S933146AbXF2HoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146AbXF2HoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 03:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764850AbXF2HoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 03:44:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48032 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764610AbXF2HoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 03:44:05 -0400
Date: Fri, 29 Jun 2007 17:43:22 +1000
From: David Chinner <dgc@sgi.com>
To: David Greaves <david@dgreaves.com>
Cc: David Chinner <dgc@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, linux-pm <linux-pm@lists.osdl.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, LinuxRaid <linux-raid@vger.kernel.org>,
       LVM general discussion and development 
	<linux-lvm@redhat.com>,
       David Robinson <zxvdr.au@gmail.com>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [linux-pm] Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
Message-ID: <20070629074322.GT31489@sgi.com>
References: <46744065.6060605@dgreaves.com> <200706281727.35430.rjw@sisk.pl> <20070628220045.GA4521@elf.ucw.cz> <200706290016.45719.rjw@sisk.pl> <20070629050024.GO31489@sgi.com> <4684B750.5030001@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4684B750.5030001@dgreaves.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 08:40:00AM +0100, David Greaves wrote:
> What happens if a filesystem is frozen and I hibernate?
> Will it be thawed when I resume?

If you froze it yourself, then you'll have to thaw it yourself.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
