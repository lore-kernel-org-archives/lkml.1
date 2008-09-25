Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbYIYCj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbYIYCj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYIYCjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:39:48 -0400
Received: from ozlabs.org ([203.10.76.45]:52837 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbYIYCjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:39:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
Date: Thu, 25 Sep 2008 12:39:29 +1000
User-Agent: KMail/1.9.9
Cc: Andi Kleen <ak@linux.intel.com>, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
References: <20080814172945.250a27f2.sfr@canb.auug.org.au> <200808171513.13611.rusty@rustcorp.com.au> <alpine.LFD.1.10.0809240353520.20067@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0809240353520.20067@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809251239.30416.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2008 17:59:41 Len Brown wrote:
> This problem first shows up with the addition of the
> acpi.power_nocheck modparam, which is staged for 2.6.28.
> Is 2.6.28 "current" or longer term?

There's a proper fix in linux-next for 2.6.28.  I was unclear about whether 
this ACPI change was going into 2.6.27; since it's not, there's no real 
issue.

Hope that helps,
Rusty.
