Return-Path: <linux-kernel-owner+w=401wt.eu-S1759017AbYDAWYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017AbYDAWYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 18:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbYDAWYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 18:24:15 -0400
Received: from ozlabs.org ([203.10.76.45]:38811 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbYDAWYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 18:24:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18418.44094.156352.405647@cargo.ozlabs.ibm.com>
Date: Wed, 2 Apr 2008 08:42:22 +1100
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc8
In-Reply-To: <alpine.LFD.1.00.0804011257310.14670@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0804011257310.14670@woody.linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> I think the dirstat continues to be fairly informative, with arch/ and 
> drivers dominating as usual. And within arch, a fair amount of the line 
> noise are all those defconfigs. I wish we had some saner way of handling 
> that

We (the arch maintainers) could try to do the bulk of the defconfig
updates at about -rc2 or -rc3 time, if you'd prefer.

Paul.
