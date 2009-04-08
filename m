Return-Path: <linux-kernel-owner+w=401wt.eu-S1762096AbZDHFYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762096AbZDHFYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761390AbZDHFWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:22:22 -0400
Received: from ozlabs.org ([203.10.76.45]:40282 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761351AbZDHFWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:22:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tim Abbott <tabbott@mit.edu>
Subject: Re: [PATCH v2 0/4] Add support for compiling with -ffunction-sections -fdata-sections
Date: Wed, 8 Apr 2009 14:52:11 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.27-11-generic; KDE/4.2.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@mit.edu>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu> <alpine.DEB.1.10.0904072019560.17274@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.1.10.0904072019560.17274@vinegar-pot.mit.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904081452.11783.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 April 2009 10:04:04 Tim Abbott wrote:
> Linus,
> 
> I see that this -ffunction-sections -fdata-sections compatability patch 
> series didn't get merged for 2.6.30-rc1.

Yep, it'd be good if Linus took this.  Pending scattered changes are
painful for everyone.

Thanks,
Rusty.
