Return-Path: <linux-kernel-owner+w=401wt.eu-S1753007AbZIZQUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbZIZQUq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 12:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbZIZQUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 12:20:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52034 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZIZQUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 12:20:45 -0400
Date: Sat, 26 Sep 2009 18:20:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [origin tree build failure] Re: [PULL] Please pull hwpoison code for 2.6.32
Message-ID: <20090926162046.GQ30185@one.firstfloor.org>
References: <20090926151740.GN30185@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090926151740.GN30185@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 09:17:34AM -0700, H. Peter Anvin wrote:
> Hardware is not the issue, but rather memory hotplug granularity for virtual environments.

That's ZONES_SHIFT, but I proposed adjusting NODES_SHIFT.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
