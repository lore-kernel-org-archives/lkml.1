Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbXFODER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbXFODER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 23:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbXFODEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 23:04:09 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:33814 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbXFODEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 23:04:08 -0400
Date: Fri, 15 Jun 2007 12:02:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: mm: Fix memory/cpu hotplug section mismatch and oops.
Message-ID: <20070615030241.GA28493@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Yasunori Goto <y-goto@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <20070614061316.GA22543@linux-sh.org> <20070614183015.9DD7.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614183015.9DD7.Y-GOTO@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 06:32:32PM +0900, Yasunori Goto wrote:
> Thanks. I tested compile with cpu/memory hotplug off/on.
> It was OK.
> 
> Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> 
It would be nice to have this for 2.6.22..
