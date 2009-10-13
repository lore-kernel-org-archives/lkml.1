Return-Path: <linux-kernel-owner+w=401wt.eu-S933024AbZJMXvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbZJMXvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 19:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760728AbZJMXvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 19:51:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55092 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbZJMXvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 19:51:16 -0400
Date: Wed, 14 Oct 2009 01:50:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwpoison: fix/proc/meminfo alignment
Message-ID: <20091013235038.GC23248@one.firstfloor.org>
References: <Pine.LNX.4.64.0910131502150.4698@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0910131502150.4698@sister.anvils>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 03:03:59PM +0100, Hugh Dickins wrote:
> Given such a long name, the kB count in /proc/meminfo's HardwareCorrupted
> line is being shown too far right (it does align with x86_64's VmallocChunk
> above, but I hope nobody will ever have that much corrupted!).  Align it.

Thanks, added.
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
