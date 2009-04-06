Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbZDFTao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbZDFTao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 15:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbZDFTad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 15:30:33 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:18669 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbZDFTad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 15:30:33 -0400
Date: Mon, 6 Apr 2009 13:31:05 -0600
From: dann frazier <dannf@hp.com>
To: Brian Maly <bmaly@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       ying.huang@intel.com, rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: add x86 support for rtc-efi
Message-ID: <20090406193105.GD21394@ldl.fc.hp.com>
References: <49DA40B9.2060804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DA40B9.2060804@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding rtc list to the CC]

On Mon, Apr 06, 2009 at 01:49:45PM -0400, Brian Maly wrote:
> This patch adds support for rtc-efi (RTC Class Driver for EFI-based  
> systems) to x86.
>
> This patch is based on dann frazier patch [add rtc platform driver for  
> EFI -> http://lkml.org/lkml/2009/1/8/434], and also depends on dann's  
> patch. Dann's patch was in the mm tree, though I think its been merged  
> already.
>
> This patch has been tested and works perfectly on every x86 EFI system I  
> could find, though all have been EL64 systems. I would appreciate any  
> testing feedback from EL32 systems from anyone that has one and can test.
>
> Signed-off-by: Brian Maly <bmaly@redhat.com>

hey Brian,
 Thanks for working on this. You might want to resubmit with the patch
inlined instead of as an attachment to make it easier to review.

-- 
dann frazier

