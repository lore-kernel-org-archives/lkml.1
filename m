Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbYDLA1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbYDLA1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 20:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758363AbYDLA1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 20:27:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41842 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246AbYDLA1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 20:27:35 -0400
Date: Sat, 12 Apr 2008 01:26:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Andy Whitcroft <apw@shadowen.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       SL Baur <steve@xemacs.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch] checkpatch: relax spacing and line length
Message-ID: <20080412002652.GM9785@ZenIV.linux.org.uk>
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr> <20080408171257.GF17915@shadowen.org> <47FCB458.3070403@panasas.com> <20080409132548.GM17915@shadowen.org> <47FCF6AF.8010703@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FCF6AF.8010703@panasas.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 08:02:39PM +0300, Benny Halevy wrote:

> I'm not sure what "two space change" proposal this Steve referred to
> and his rejection is based on not-to-sound aesthetic grounds.
> 
> The motivation behind our proposal is more than just aesthetic.
> I believe that using tabs for indent and then spaces for alignment
> is functionally better, works for everybody, and will eventually result
> in a more readable code over time, hopefully leading to fewer bugs.

Sorry.  I'm not going to change perfectly working editing habits *or* to patch
nvi to satisfy an annoying wunch of bankers.  HAND, GAFL.
