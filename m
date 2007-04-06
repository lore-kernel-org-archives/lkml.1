Return-Path: <linux-kernel-owner+w=401wt.eu-S933277AbXDFQnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277AbXDFQnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 12:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933279AbXDFQnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 12:43:51 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55526 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933277AbXDFQnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 12:43:50 -0400
Date: Fri, 6 Apr 2007 09:43:42 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: sky2 still broken in 2.6.20.3
Message-ID: <20070406094342.0143a150@freekitty>
In-Reply-To: <4601950D.5000503@redhat.com>
References: <4601950D.5000503@redhat.com>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 16:26:53 -0400
Chuck Ebbert <cebbert@redhat.com> wrote:

> Transmit timeouts and locked-up adapters still occur in kernel
> 2.6.20.3.  It looks like the patch that was applied to 2.6.20.2
> is not enough. Unfortunately that one isn't the same as what
> went upstream. Looks like it needs to be reverted, then the two
> upstream patches applied?

Which chipset do you have?  I am currently working on problems with
the 88e8056.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
