Return-Path: <linux-kernel-owner+w=401wt.eu-S1161560AbXD2XqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161560AbXD2XqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161579AbXD2XqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:46:16 -0400
Received: from ns.suse.de ([195.135.220.2]:41919 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161575AbXD2XqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:14 -0400
From: Andi Kleen <ak@suse.de>
Message-Id: <20070430146.588463000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/26] x86 candidate patches for review IV: more misc patches
Date: Mon, 30 Apr 2007 01:46:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


- New smp_ops interface to handle Xen and other non APIC subarchitectures cleanly
- Fix vmalloc_32() on 64bit systems
- Finally fix compat vDSO
- Initial per CPU cleanups. Now the in core kernel per cpu data 
doesn't have a upper limit anymore.
- Some AMD Family 10h support
- Many cleanups 

Please review.

-Andi

