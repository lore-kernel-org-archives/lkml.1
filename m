Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbZGFQvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbZGFQvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 12:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbZGFQvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 12:51:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33627 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbZGFQvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 12:51:21 -0400
Date: Mon, 6 Jul 2009 19:50:45 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v9 5/5] KVM: create irqfd-cleanup-wq on demand
Message-ID: <20090706165045.GF12399@redhat.com>
References: <20090702153454.20186.99191.stgit@dev.haskins.net> <20090702153821.20186.9344.stgit@dev.haskins.net> <20090706155850.GA12399@redhat.com> <4A522050.7030200@novell.com> <20090706161444.GC12399@redhat.com> <4A52272A.2060101@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A52272A.2060101@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 12:32:42PM -0400, Gregory Haskins wrote:
> For the record, I would have rather just used my originally proposed
> slow-work thread instead of all this ;)

Or just keep the idle thread around, it's not a big deal.

-- 
MST
