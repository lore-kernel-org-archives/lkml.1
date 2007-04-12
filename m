Return-Path: <linux-kernel-owner+w=401wt.eu-S1751576AbXDLNzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbXDLNzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 09:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbXDLNzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 09:55:13 -0400
Received: from main.gmane.org ([80.91.229.2]:51826 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbXDLNzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 09:55:12 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: Add a norecovery option to ext3/4?
Date: 12 Apr 2007 15:54:49 +0200
Message-ID: <m3k5wh66l2.fsf@ursa.amorsen.dk>
References: <20070409000556.GA13980@implementation> <461A5F13.7040705@cfl.rr.com> <461A760B.1040103@redhat.com> <461BDD48.2000904@cfl.rr.com> <461BE2FB.5090101@redhat.com> <461D407C.3030706@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 10.8.185.213.dk-amb.res.sta.perspektivbredband.net
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
Cc: linux-ext4@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "BD" == Bill Davidsen <davidsen@tmr.com> writes:

BD> In practice Linux has had lots of practice mounting garbage, and
BD> isn't likely to suffer terminal damage.

These days, with exposed USB ports and automount, it is rather
important that the kernel doesn't suffer terminal damage when mounting
garbage. It is too easy to exploit.


/Benny


