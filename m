Return-Path: <linux-kernel-owner+w=401wt.eu-S1161325AbXCONX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161325AbXCONX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 09:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161022AbXCONX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 09:23:59 -0400
Received: from ns.suse.de ([195.135.220.2]:52753 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933543AbXCONX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 09:23:58 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: PCI DAC DMA APIs
Date: Thu, 15 Mar 2007 14:23:54 +0100
User-Agent: KMail/1.9.5
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <45F94C45.76E4.0078.0@novell.com>
In-Reply-To: <45F94C45.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703151423.54266.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 March 2007 13:38, Jan Beulich wrote:
> While the kernel headers provide for this, there don't appear to be any
> in-tree users (which seems contrary to general Linux policies). Would there
> be objections to remove all of these?

Would be fine for me.

I think the original idea was to optimize for some SPARC systems, but they
were never really used for that.

x86 never needed them.

-Andi
