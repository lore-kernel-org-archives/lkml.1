Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbZFYS11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbZFYS11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 14:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZFYS1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 14:27:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59634 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbZFYS1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 14:27:16 -0400
Date: Thu, 25 Jun 2009 21:26:36 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: avi@redhat.com, Davide Libenzi <davidel@xmailserver.org>,
       Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
	notifier race conditions
Message-ID: <20090625182636.GA3239@redhat.com>
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <200906241255.54709.rusty@rustcorp.com.au> <alpine.DEB.1.10.0906241154350.30928@makko.or.mcafeemobile.com> <200906252112.24730.rusty@rustcorp.com.au> <alpine.DEB.1.10.0906250922530.9517@makko.or.mcafeemobile.com> <4A43B4A6.8050001@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A43B4A6.8050001@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 01:32:22PM -0400, Gregory Haskins wrote:
> Please take a close look at it and consider for merging, if you would.

With all the incremental patching, I kind of lost track of what the
complete file would look like.  Is there a git tree I could pull?

-- 
MST
