Return-Path: <linux-kernel-owner+w=401wt.eu-S1759645AbXGFN2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645AbXGFN2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 09:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbXGFN2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 09:28:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:33456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbXGFN2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 09:28:24 -0400
Date: Fri, 6 Jul 2007 15:28:14 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: Determine version of kernel that produced vmcore
Message-ID: <20070706132814.GA7079@suse.de>
Mail-Followup-To: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

does anybody know a _reliable_ way to determine the version the kernel
that produced a vmcore file? This means not scanning for a specific
string or something like that which can fail on random memory.

Would it make sense to add a ELF PT_NOTE section in the vmcore?

Thanks for input!



Thanks,
   Bernhard
