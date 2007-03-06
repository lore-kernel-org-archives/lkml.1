Return-Path: <linux-kernel-owner+w=401wt.eu-S933727AbXCFBMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727AbXCFBMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 20:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933738AbXCFBMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 20:12:24 -0500
Received: from ozlabs.org ([203.10.76.45]:36992 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933727AbXCFBMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 20:12:23 -0500
Subject: Re: [patch] paravirt: VDSO page is essential
From: Rusty Russell <rusty@rustcorp.com.au>
To: Zachary Amsden <zach@vmware.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Andi Kleen <ak@suse.de>, virtualization <virtualization@lists.osdl.org>
In-Reply-To: <45ECBDDC.8080708@vmware.com>
References: <20070305120631.GA14105@elte.hu>
	 <1173101297.26165.39.camel@localhost.localdomain>
	 <1173142644.4644.6.camel@localhost.localdomain>
	 <45ECBDDC.8080708@vmware.com>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 12:11:25 +1100
Message-Id: <1173143485.4644.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 17:03 -0800, Zachary Amsden wrote:
> Rusty Russell wrote:
> > This still need some work (doing that now), but do people like the idea?
> >
> I had just sent this out for internal review...

Spooky!

I was just testing with lguest, but I'll do so with your patch instead.

Thanks,
Rusty.


