Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbZFDVnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbZFDVnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 17:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbZFDVnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 17:43:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43034 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803AbZFDVnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 17:43:22 -0400
Date: Thu, 4 Jun 2009 17:43:01 -0400
From: Dave Jones <davej@redhat.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Message-ID: <20090604214301.GB20822@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Michael S. Zick" <lkml@morethan.org>,
	Harald Welte <HaraldWelte@viatech.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Duane Griffin <duaneg@dghda.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906041601.33400.lkml@morethan.org> <20090604212454.GA20822@redhat.com> <200906041638.15480.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906041638.15480.lkml@morethan.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 04:38:13PM -0500, Michael S. Zick wrote:
 > I have already preceded that chunk of code with a printk and confirmed
 > that x86_clflush_size is properly set to 64 bytes (somewhere else).
 > 
 > So your suggestion is the obvious one for the C7-M,
 > I don't know about any other makes/models. 
 > 
 > This machine's C7-M is being reported as a "stepping 0" ??
 > What is earlier than a stepping 0 ??

Earlier model numbers.
(Stepping gets reset to 0 every time they bump the model)

	Dave

