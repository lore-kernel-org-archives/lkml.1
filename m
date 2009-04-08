Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbZDHAg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbZDHAg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 20:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZDHAgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 20:36:17 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:40087 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754600AbZDHAgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 20:36:17 -0400
Date: Tue, 7 Apr 2009 20:34:04 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>
Subject: Re: [PATCH v2 0/4] Add support for compiling with -ffunction-sections
 -fdata-sections
In-Reply-To: <1238973278-31735-1-git-send-email-tabbott@mit.edu>
Message-ID: <alpine.DEB.1.10.0904072019560.17274@vinegar-pot.mit.edu>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

I see that this -ffunction-sections -fdata-sections compatability patch 
series didn't get merged for 2.6.30-rc1.  Is there a problem with the 
patches that needs to be addressed?  Or are you planning to merge it 
sometime later in this release cycle (Stephen Rothwell mentioned just 
after -rc1 as a good time for these patches)?

It still applies to both linux-next and 2.6.30-rc1.  

	Thanks,
	-Tim Abbott
