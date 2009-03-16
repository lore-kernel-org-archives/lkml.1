Return-Path: <linux-kernel-owner+w=401wt.eu-S1752218AbZCPPO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbZCPPO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 11:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZCPPOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 11:14:50 -0400
Received: from usps1.crhc.illinois.edu ([130.126.143.230]:39049 "EHLO
	usps.crhc.uiuc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZCPPOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 11:14:49 -0400
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2009 11:14:49 EDT
From: "Long Wang" <longwang@crhc.illinois.edu>
To: <xen-devel@lists.xensource.com>
Cc: "'the arch/x86 maintainers'" <x86@kernel.org>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: how to enable shadow page table? Do I have to run HVM guest systems for shadow paging mode?
Date: Mon, 16 Mar 2009 10:05:36 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook, Build 11.0.5510
Thread-Index: AcmmQmY7eVOkcqF1ThC6tCxQekAQiQABfUxA
In-Reply-To: <49BE6027.60805@goop.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Message-Id: <20090316150521.855E33400090@usps.crhc.uiuc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am working on a research project based on Xen 3.3.1. I want to use the
shadow page table for setting guest system memory pages as read-only and/or
dirty, and perform a copy-on-write mechanism when these memory pages are
updated. I heard that auto_translated_physmap is not supported any more. 

Then how can I enable shadow page table? Do I have to run HVM guest systems
to have shadow paging mode? Can I enable shadow paging mode in PV?

I look forward to your help on this problem. Thank you very much,

Sincerely,
Long Wang


