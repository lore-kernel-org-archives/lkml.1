Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbXDNQgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbXDNQgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 12:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbXDNQgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 12:36:46 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:16845 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbXDNQgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 12:36:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:organization:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=NkCGPVq9aLIX3iZc6wUYMZZ9t73RquF94ji5y6PA6YMtgUhbjoUdXFnC/Zw96y35tEbV2FKpleBrjimZc3RfHSi1AT0hcQnPvICvoPOrY4fzDUsME2nE0LDNXcD22jQ4SzwwSQap146dVkYpg3fcpPAcKacjKsRbzP3rB/+dS+w=
Organization: Organization? Not detectable
To: lkml <linux-kernel@vger.kernel.org>
Subject: What the heck?
Date: Sat, 14 Apr 2007 12:36:41 -0400
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704141236.41070.gene.heskett@verizon.net>
From: Gene Heskett <gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have been diligently putting the spam emitters into my .procmailrc file, so 
that anything that comes from them goes to /dev/null.

This included mailbag1.bizmailsrvcs.net and mailbag2.bizmailsrvcs.net.

The linux kernel mailing list disappeared!  Turning on VERBOSE and watching 
the procmail.log with tail disclosed that it was triggering on those 2 mail 
servers, which I thought had nothing to do with vger.kernel.org

I've removed them from by procmail recipes now, but I'd sure like to know 
wtf's going on.  These 2 servers are a major source of incoming spam 
according to the headers of the spams received.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
That's easy to fix, but I can't be bothered.
