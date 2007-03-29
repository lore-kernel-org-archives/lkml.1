Return-Path: <linux-kernel-owner+w=401wt.eu-S1030678AbXC2UbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030678AbXC2UbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 16:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030684AbXC2UbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 16:31:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030678AbXC2UbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 16:31:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alexey Dobriyan <adobriyan@sw.ru>
X-Fcc: ~/Mail/utrace
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: utrace, RCU and ia64
In-Reply-To: Alexey Dobriyan's message of  Thursday, 29 March 2007 21:07:31 +0400 <20070329170731.GA6808@localhost.sw.ru>
Emacs: because Hell was full.
Message-Id: <20070329203025.540841801C4@magilla.sf.frob.com>
Date: Thu, 29 Mar 2007 13:30:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the reports.  I have a handle on a bug that probably is at
fault, and I'm working on a fix.


Thanks,
Roland
