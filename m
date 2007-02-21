Return-Path: <linux-kernel-owner+w=401wt.eu-S1422809AbXBUTJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422809AbXBUTJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422820AbXBUTJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:09:24 -0500
Received: from ozlabs.org ([203.10.76.45]:34091 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422809AbXBUTJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:09:23 -0500
Subject: Re: [kvm-devel] [PATCH 0/6] KVM userspace interface updates for
	2.6.21
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Cc: Andrew Morton <akpm@osdl.org>, kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <45DC8D97.9060408@qumranet.com>
References: <45DC8B6E.5050205@qumranet.com>  <45DC8D97.9060408@qumranet.com>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 06:08:30 +1100
Message-Id: <1172084910.13378.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 20:21 +0200, Avi Kivity wrote:
> Avi Kivity wrote:
> > The following patchset moves the kvm userspace interface from having a 
> > single fd, to having three types of file descriptors:
> 
> Andrew, while the 2.6.21 merge window has closed, please consider 
> applying this to 2.6.21 anyway.

Oh yeah, me too!

Lguest now offers a level of instability users of 2.6.21 should enjoy.

Plus, despite lguest having no stable ABI, I've only changed it once vs.
kvm's twice.  I hope to do better in future, but until it's in mainline
that's hard.

Rusty.

