Return-Path: <linux-kernel-owner+w=401wt.eu-S1764693AbXF1Pp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764693AbXF1Pp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757462AbXF1PpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:45:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399AbXF1PpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:45:16 -0400
Message-ID: <4683D762.7070609@redhat.com>
Date: Thu, 28 Jun 2007 11:44:34 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Bill Davidsen <davidsen@tmr.com>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Shaohua Li <shaohua.li@intel.com>, jamagallon@ono.com,
       tigran@aivazian.fsnet.co.uk,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New format Intel microcode...
References: <6278d2220703221645j760a8816v4b8749ea2d60e493@mail.gmail.com> <1174610594.6598.3.camel@sli10-conroe.sh.intel.com> <6278d2220706261442u9b137c5xb6225b3f56605554@mail.gmail.com> <p731wfy5m74.fsf@bingen.suse.de> <4683BD56.7070707@tmr.com> <20070628152747.GA14519@one.firstfloor.org>
In-Reply-To: <20070628152747.GA14519@one.firstfloor.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2007 11:27 AM, Andi Kleen wrote:
> 
> But the problem is very obscure and you can likely ignore it too. If your 
> machine crashes it's very likely something else.

What about deliberate exploits of these bugs from userspace? Theo thinks
they are possible...

