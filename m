Return-Path: <linux-kernel-owner+w=401wt.eu-S932842AbZJFOj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842AbZJFOj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932820AbZJFOj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:39:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57381 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932819AbZJFOjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:39:55 -0400
Subject: Re: Linux 2.6.32-rc3
From: Dirk Hohndel <hohndel@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
	 <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>
	 <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>
	 <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Tue, 06 Oct 2009 07:38:51 -0700
Message-Id: <1254839931.24117.9.camel@dhohndel-mobl.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hohndel@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 07:18 -0700, Linus Torvalds wrote:
> So no. I'm not going to do -rc0. Because doing that is _stupid_. And until 
> you understand _why_ it's stupid, it's pointless talking about it, and 
> when you _do_ understand that it's stupid, you'll agree with me.

I respectfully disagree.

With the proposed -rc0 there is EXACTLY ONE kernel that is called 2.6.31
- the release kernel. And everything else is called something
2.6.xx-rcY.

So we do get very useful information here - especially since the release
kernel is supposed to be reasonably stable whereas the things right
afterwards (during the merge window) are extremely likely to be
unstable.

So if you see something that identifies itself as -rc0, you know it's
from during the merge window. If you see something that calls itself
2.6.xx then you know it's a release kernel.

/D

-- 
Dirk Hohndel
Intel Open Source Technology Center

