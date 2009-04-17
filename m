Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbZDQFVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbZDQFVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 01:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZDQFVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 01:21:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33218 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbZDQFVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 01:21:37 -0400
Date: Fri, 17 Apr 2009 07:24:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bug #13098] 2.6.29-git12 breaks vga=0x0f07 on MSI/Intel GPU
Message-ID: <20090417052437.GJ14687@one.firstfloor.org>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.L8.dw85JB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nY3-4PrO6XH.A.L8.dw85JB@chimera>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 11:45:03PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13098
> Subject		: 2.6.29-git12 breaks vga=0x0f07 on MSI/Intel GPU
> Submitter	: Andi Kleen <andi@firstfloor.org>
> Date		: 2009-04-06 01:14 (11 days old)
> References	: http://lkml.org/lkml/2009/4/5/200
> Handled-By	: H. Peter Anvin <hpa@zytor.com>

That's already fixed with 5f641356127712fbdce0eee120e5ce115860c17f I think.
At least it works again on my test box with the rcs.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
