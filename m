Return-Path: <linux-kernel-owner+w=401wt.eu-S1758539AbYDDHVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539AbYDDHVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 03:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757200AbYDDHUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 03:20:37 -0400
Received: from oss.sgi.com ([192.48.170.157]:53593 "EHLO oss.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756998AbYDDHU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 03:20:27 -0400
Date: Fri, 4 Apr 2008 08:20:20 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] [MIPS] unexport rtc_mips_set_time()
Message-ID: <20080404072020.GE12086@linux-mips.org>
References: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com> <1207094318-21748-5-git-send-email-dmitri.vorobiev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207094318-21748-5-git-send-email-dmitri.vorobiev@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 03:58:37AM +0400, Dmitri Vorobiev wrote:

> No users for the rtc_mips_set_time() routine exist outside of the
> core kernel code. Therefore, EXPORT_SYMBOL(rtc_mips_set_time) is
> useless, and this patch removes it.
> 
> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>

Queued for 2.6.26.  Thanks,

  Ralf
