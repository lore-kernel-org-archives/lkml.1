Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbXD2TIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbXD2TIj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 15:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbXD2TIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 15:08:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbXD2TIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 15:08:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Fcc: ~/Mail/linus
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Zachary Amsden <zach@vmware.com>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 03/32] xen: Add nosegneg capability to the vsyscall page notes
In-Reply-To: Jeremy Fitzhardinge's message of  Sunday, 29 April 2007 10:28:38 -0700 <20070429172910.877994000@goop.org>
X-Windows: the defacto substandard.
Message-Id: <20070429190830.0CF571801A4@magilla.sf.frob.com>
Date: Sun, 29 Apr 2007 12:08:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wouldn't add that macro to asm/elf.h.  There is nothing magical or
standard about that number.


Thanks,
Roland
