Return-Path: <linux-kernel-owner+w=401wt.eu-S933382AbXDFXZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382AbXDFXZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 19:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933410AbXDFXZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 19:25:09 -0400
Received: from gw.goop.org ([64.81.55.164]:44076 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933382AbXDFXZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 19:25:06 -0400
Message-ID: <4616D6A1.5050908@goop.org>
Date: Fri, 06 Apr 2007 16:24:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@suse.de>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>
Subject: Re: [patch 09/20] rename struct paravirt_patch to paravirt_patch_site
 for clarity
References: <20070404191151.009821039@goop.org>	<20070404191205.617690202@goop.org> <20070406161822.a9f828a4.akpm@linux-foundation.org>
In-Reply-To: <20070406161822.a9f828a4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Needed a bit of updating for Andi's recently-merged
> x86_64-mm-vmi-backend-for-paravirt-ops.patch but I think I got it
> right.  We'll see if it compiles.
>   

Yeah, it's just a simple name change, so it will either compile or not.

    J
