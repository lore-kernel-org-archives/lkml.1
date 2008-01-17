Return-Path: <linux-kernel-owner+w=401wt.eu-S1757462AbYAQTzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbYAQTzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbYAQTzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:55:32 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:56185 "EHLO
	mail116-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbYAQTzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:55:31 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Thu, 17 Jan 2008 20:54:22 +0100
From: "Andreas Herrmann3" <andreas.herrmann3@amd.com>
To: "Venki Pallipadi" <venkatesh.pallipadi@intel.com>
cc: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug
 fixes
Message-ID: <20080117195422.GB12631@alberich.amd.com>
References: <20080116023955.597433000@intel.com>
 <20080116185748.GA11244@alberich.amd.com>
 <20080116203328.GA17869@linux-os.sc.intel.com>
 <20080117191211.GA12631@alberich.amd.com>
MIME-Version: 1.0
In-Reply-To: <20080117191211.GA12631@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Jan 2008 19:54:07.0883 (UTC)
 FILETIME=[B88A15B0:01C85942]
X-WSS-ID: 6B916DE807S8350380-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 08:12:11PM +0100, Andreas Herrmann3 wrote:
> On Wed, Jan 16, 2008 at 12:33:28PM -0800, Venki Pallipadi wrote:

  <snip>

> 
> I guess the conflict for sata is
>     ioremap: addr c0403104, size fc
>     ioremap_nocache: addr c0403000, size 200
> 
> But where does the conflict for the sound card
> (ioremap_nocache: addr c0403800, size 100)
> come from?

Sorry, forget this dumb question. Its the
same page as above.


Andreas




