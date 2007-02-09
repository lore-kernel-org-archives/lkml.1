Return-Path: <linux-kernel-owner+w=401wt.eu-S1946494AbXBIPAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946494AbXBIPAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946483AbXBIPAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:00:01 -0500
Received: from ozlabs.org ([203.10.76.45]:46972 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946494AbXBIPAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:00:00 -0500
Subject: [PATCH 0 of 7]  lguest host code
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.osdl.org>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 01:59:06 +1100
Message-Id: <1171033146.2718.157.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These seven patches replace [PATCH 6/10], or in the second send, patches
6a. 6b, 6c and 6d.

There are more patches because Andi hassled me about extern decls, so I
had to expose some things.  Tiny patches, but worth separating because
you never know when such changes will break something.  Compiles and
runs here...

Thanks,
Rusty.


