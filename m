Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbYDHI2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbYDHI2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYDHI2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:28:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbYDHI2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:28:46 -0400
Date: Tue, 8 Apr 2008 01:28:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "eric miao" <eric.y.miao@gmail.com>
Cc: "linux-arm-kernel email list" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 0/4] pxafb: add smartpanel support
Message-Id: <20080408012818.abaaf799.akpm@linux-foundation.org>
In-Reply-To: <f17812d70804072101u1244c864s2f8d2ec1c9f96239@mail.gmail.com>
References: <f17812d70804072101u1244c864s2f8d2ec1c9f96239@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008 12:01:25 +0800 "eric miao" <eric.y.miao@gmail.com> wrote:

> There are 4 patches as listed below:
> 
> 0001 - pxafb: introduce lcd_{read,write}l() to wrap the __raw_{read,write}l()
> 0002 - pxafb: use completion for LCD disable wait code
> 0003 - pxafb: move parallel LCD timing setup into dedicate function
> 0004 - pxafb: preliminary smart panel interface support

I had to fix rather a lot of wordwrapping in these patches.  Please fix up
your email client for next time, thanks.
