Return-Path: <linux-kernel-owner+w=401wt.eu-S934516AbZC0BoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934516AbZC0BoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 21:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759859AbZC0BoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 21:44:11 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:38471 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759219AbZC0BoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 21:44:10 -0400
Date: Thu, 26 Mar 2009 21:41:59 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Jeff Arnold <jbarnold@MIT.EDU>
Subject: Re: [PATCH 0/4] Add support for compiling with -ffunction-sections
 -fdata-sections
In-Reply-To: <49C8F24D.6000603@zytor.com>
Message-ID: <alpine.DEB.1.10.0903261538090.7289@vinegar-pot.mit.edu>
References: <1237872525-31014-1-git-send-email-tabbott@mit.edu> <20090324170700.6029f6ce.sfr@canb.auug.org.au> <alpine.DEB.1.10.0903240210410.21037@vinegar-pot.mit.edu> <49C8F24D.6000603@zytor.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009, H. Peter Anvin wrote:

> "Just before -rc1" is pretty much the only time to do this kind of changes.
> It's not the first time we have had this issue.

OK.  Merging this patch just before -rc1 would be fine with me; I'll keep 
the patch series updated as the merge window proceeds.

How should I help this patch be merged "just before -rc1"?  In particular, 
how will I know when is the right time to send the updated patch?

	-Tim Abbott
