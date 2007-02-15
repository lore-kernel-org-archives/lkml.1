Return-Path: <linux-kernel-owner+w=401wt.eu-S1030295AbXBORLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030295AbXBORLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 12:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030298AbXBORLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 12:11:45 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:37151 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030295AbXBORLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 12:11:44 -0500
Date: Thu, 15 Feb 2007 12:01:54 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Blaisorblade <blaisorblade@yahoo.it>,
       user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, stable@kernel.org
Subject: Re: [uml-devel] x86_64: fix 2.6.18 regression - PTRACE_OLDSETOPTIONS should be accepted
Message-ID: <20070215170154.GA5641@ccure.user-mode-linux.org>
References: <11715068631914-git-send-email-blaisorblade@yahoo.it> <20070215025423.GA9300@ccure.user-mode-linux.org> <200702150443.42287.blaisorblade@yahoo.it> <20070214215123.57ef2d4a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214215123.57ef2d4a.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 09:51:23PM -0800, Andrew Morton wrote:
> Whatever happens, please ensure that the final fix makes it into -stable
> as well.  Jeff's version of this patch wasn't cc'ed to stable@kernel.org.

Paolo's patch was sent to -stable.  His should be used everywhere, and mine
should be dropped.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
