Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbXJWHoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbXJWHoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXJWHoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:44:12 -0400
Received: from ozlabs.org ([203.10.76.45]:48083 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbXJWHoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:44:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [git pull] lguest: paravirt boot code
Date: Tue, 23 Oct 2007 17:44:15 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: virtualization@lists.linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lguest <lguest@ozlabs.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
References: <200710221237.14542.rusty@rustcorp.com.au> <200710231603.21620.rusty@rustcorp.com.au> <200710230855.06253.borntraeger@de.ibm.com>
In-Reply-To: <200710230855.06253.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710231744.16296.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 October 2007 16:55:06 Christian Borntraeger wrote:
> Having virtio in Linus tree would make my life easier wiring it up for
> virtualization on s390.

Indeed.  And given lguest's lack of interface guarantees, it make sense to use 
it as the first virtio guinea pig.  I expect changes as we adapt it for 
others anyway.

> That reminds me that I promised Rusty to look at one small issue in virtio
> net driver. Nothing that should hold of the merge. I will sent the patch
> via Rusty when its ready.

Thanks,
Rusty.
