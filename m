Return-Path: <linux-kernel-owner+w=401wt.eu-S934444AbXEVO6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934444AbXEVO6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 10:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbXEVO6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 10:58:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:48435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289AbXEVO6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 10:58:35 -0400
From: Andi Kleen <ak@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 00/33] xen: Xen paravirt_ops implementation
Date: Tue, 22 May 2007 16:57:53 +0200
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
References: <20070522140941.802382212@goop.org>
In-Reply-To: <20070522140941.802382212@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705221657.53607.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 May 2007 16:09, Jeremy Fitzhardinge wrote:

>
> This is the Xen implementation for the paravirt_ops interface.  The
> series is based on 2.6.22-rc1-mm1, and I think its ready to be cooked
> in -mm with a view to being merged in 2.6.23.

I already got it in my tree now from your previous post. Does this
version have changes over that one? 

-Andi
