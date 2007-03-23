Return-Path: <linux-kernel-owner+w=401wt.eu-S1422649AbXCWBL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422649AbXCWBL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 21:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422638AbXCWBLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 21:11:24 -0400
Received: from ozlabs.org ([203.10.76.45]:36898 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422640AbXCWBKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 21:10:45 -0400
Subject: Re: [PATCH] make KVM conform to sucky rdmsr interface
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@qumranet.com>, Andi Kleen <ak@muc.de>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <20070322143011.0cf83370.akpm@linux-foundation.org>
References: <1174531917.2713.91.camel@localhost.localdomain>
	 <46022E40.8080300@qumranet.com>
	 <1174549770.2713.121.camel@localhost.localdomain>
	 <20070322143011.0cf83370.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 12:10:43 +1100
Message-Id: <1174612243.2713.162.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 14:30 -0700, Andrew Morton wrote:
> Which tree are you patching??

We crossed in the mail: you turfed out the paravirt.h cleanup patch it
applied to.

We have rolled the fixes one patch, and am testing...

Rusty.


