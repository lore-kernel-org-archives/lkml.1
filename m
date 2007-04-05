Return-Path: <linux-kernel-owner+w=401wt.eu-S1767450AbXDEXyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767450AbXDEXyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 19:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767449AbXDEXyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 19:54:53 -0400
Received: from ns2.suse.de ([195.135.220.15]:36883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767450AbXDEXyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 19:54:52 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] Bugfix for VMI paravirt ops
Date: Fri, 6 Apr 2007 01:54:41 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
References: <46158674.5090709@vmware.com>
In-Reply-To: <46158674.5090709@vmware.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704060154.41574.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 April 2007 01:29:56 Zachary Amsden wrote:
> I noticed this never got applied.  There was some feedback which I did 
> not include in this patch because I think it is inappropriate to touch 
> code outside vmi.c at this point for 2.6.21. 

I think it is. That is why i didn't apply it.

-Andi
