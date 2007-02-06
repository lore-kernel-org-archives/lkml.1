Return-Path: <linux-kernel-owner+w=401wt.eu-S1752390AbXBFE1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbXBFE1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 23:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbXBFE1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 23:27:49 -0500
Received: from ozlabs.org ([203.10.76.45]:38862 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbXBFE1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 23:27:48 -0500
Subject: Re: [PATCH 0/11] VMI / Paravirt bugfixes for 2.6.21
From: Rusty Russell <rusty@rustcorp.com.au>
To: Zachary Amsden <zach@vmware.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <200702060352.l163q87K000713@zach-dev.vmware.com>
References: <200702060352.l163q87K000713@zach-dev.vmware.com>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 15:27:09 +1100
Message-Id: <1170736029.29293.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 19:52 -0800, Zachary Amsden wrote:
> A bunch of VMI and paravirt-ops bugfixes for upstream.  Also, fix the
> timer code to work for 2.6.21, which had a number of changes.
> 
> These should mostly be non-controversial and beneficial to all the
> paravirt-ops work.

Indeed, I'm expecting to push lguest this week, and this code will
effect me, so I'd like to see this in a -mm soon...

Thanks!
Rusty.


