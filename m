Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbYAQSA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbYAQSA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbYAQSAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:00:06 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:43230 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690AbYAQSAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:00:04 -0500
Date: Thu, 17 Jan 2008 12:59:51 -0500
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [-mm Patch] UML: fix a building error
Message-ID: <20080117175951.GB4385@c2.user-mode-linux.org>
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <20080117132108.GC2693@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117132108.GC2693@hacking>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 09:21:08PM +0800, WANG Cong wrote:
> Building uml failed in current -mm tree. ;(
> 
> The below patch fixes this building error:
> ...
> include/asm/arch/system.h:8:22: error: asm/nops.h: No such file or directory
> ...
> 
> Cc: Jeff Dike <jdike@addtoit.com>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

ACK

	Jeff

-- 
Work email - jdike at linux dot intel dot com
